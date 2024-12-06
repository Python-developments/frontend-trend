import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/features/posts/data/models/params/add_post_params.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:image/image.dart' as img;

class AddNewPostPage extends StatefulWidget {
  final Function? function;
  const AddNewPostPage({this.function});

  @override
  State<AddNewPostPage> createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  File? file;
  // bool isVlog = false;
  bool isLoading = false;
  // late VideoPlayerController videoPlayerController;
  /*Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Do something with the picked file
      String dir = pathy.dirname(pickedFile.path);
      String fileExtendsion = pickedFile.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fullName = 'image_$timestamp.$fileExtendsion';
      String newName = pathy.join(dir, fullName);
      file = File(pickedFile.path).renameSync(newName);
      isVlog = true;
      videoPlayerController = VideoPlayerController.file(file!)
        ..initialize().then((_) {
          setState(
              () {}); // Ensure the first frame is shown after the video is initialized
        });
      _scrollToEnd();
    } else {
      print('No image selected.');
    }
  }
*/
  double imageHeight = 0;
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Do something with the picked file

      file = File(pickedFile.path);
      final img.Image image = img.decodeImage(await pickedFile.readAsBytes())!;
      imageHeight = image.height.toDouble();
      // isVlog = false;

      setState(() {});
      await Future.delayed(Duration(milliseconds: 200));
      _scrollToEnd();
    } else {
      print('No image selected.');
    }
  }

  TextEditingController _descriptionController = TextEditingController();
  /*void peformAddVlog() async {
    context.read<VlogsBloc>().add(AddVlogEvent(
        params: AddVlogParams(
            videoFile: file!,
            description: _descriptionController.text.trim())));
  }*/

  void peformAddPost() async {
    // imageHeight
    String postDescription = _descriptionController.text.trim();
    String postHeightWithDescription =
        postDescription + "&&&&****&&&&" + imageHeight.toString();
    log(postHeightWithDescription);
    context.read<PostsBloc>().add(AddPostEvent(
        params: AddPostParams(
            imageFile: file!, description: postHeightWithDescription)));
  }

  ScrollController scrollController = ScrollController();
  void _scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> requestPermissions() async {
    return true;
    // final status = await Permission.photos.request();
    // if (status.isGranted) {
    //   return true;
    // } else if (status.isDenied) {
    //   // Show a message or prompt the user to grant permission
    //   Permission.photos.request();
    // } else if (status.isPermanentlyDenied) {
    //   // Show a dialog and guide the user to the app settings to enable permission
    //   openAppSettings();
    //   // Opens app settings page
    // }
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              SizedBox(
                width: 20.sp,
              ),
              Text(
                "Add a new post",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return (state is PostsLoadingState)
                    ? const LinearProgressIndicator()
                    : (state is PostsLoadingState)
                        ? SizedBox(height: 10)
                        : (state is! PostsLoadingState)
                            ? const Divider()
                            : SizedBox.shrink();
              }),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  file == null
                      ? SizedBox()
                      : BlocConsumer<PostsBloc, PostsState>(
                          listener: (context, state) {
                          if (state is PostsNoInternetConnectionState) {
                            ToastUtils(context).showNoInternetConnectionToast();
                          } else if (state is PostsErrorState) {
                            ToastUtils(context)
                                .showCustomToast(message: state.message);
                          } else if (state is PostAddedSuccessState) {
                            ToastUtils(context).showCustomToast(
                                message: "Post added successfully".hardcoded);
                            if (widget.function != null) {
                              widget.function!(0);
                            }
                            context.go(Routes.posts);
                          }
                        }, builder: (context, state) {
                          return Column(
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffF5F5F7)),
                                    borderRadius: BorderRadius.circular(10.sp)),
                                margin: EdgeInsets.symmetric(horizontal: 30.sp),
                                height: 500.sp,
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          );
                        }),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.sp)),
                    margin: EdgeInsets.all(15.sp),
                    padding: EdgeInsets.all(15.sp),
                    child: Column(
                      children: [
                        TextFormField(
                          onTap: () async {
                            await Future.delayed(Duration(milliseconds: 200));
                            _scrollToEnd();
                          },
                          style: TextStyle(color: Colors.black),
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: "Make description...",
                              filled: true,
                              fillColor: Color(0xffF9F9FC),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6.sp))),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            InkWell(
                                child: InkWell(
                              onTap: () async {
                                bool x = await requestPermissions();
                                if (x) {
                                  _pickImage(ImageSource.gallery);
                                }
                                //
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                                child: SvgPicture.asset(
                                    'assets/icons/single_post/gallery.svg'),
                              ),
                            )),
                            InkWell(
                                child: InkWell(
                              onTap: () async {
                                bool x = await requestPermissions();
                                if (x) {
                                  _pickImage(ImageSource.camera);
                                }
                              },
                              child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.sp),
                                  child: SvgPicture.asset(
                                      'assets/icons/single_post/camera.svg')),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Divider(
                          color: Color(0xffF5F5F7),
                          indent: 0,
                          height: 0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 35.sp, horizontal: 25.sp),
        height: 40.sp,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
            onPressed: file == null || isLoading
                ? null
                : () {
                    isLoading = true;
                    setState(() {});

                    peformAddPost();
                  },
            child: Text(
              "Save & Share",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
