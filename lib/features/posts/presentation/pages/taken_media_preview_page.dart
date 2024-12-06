import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../data/models/params/add_post_params.dart';
import '../../data/models/post_media_type_enum.dart';
import '../bloc/posts_bloc/posts_bloc.dart';

import '../../../../core/utils/toast_utils.dart';

class TakenMediaPreviewPage extends StatefulWidget {
  final List<File> files;
  final PostMediaType mediaType;
  const TakenMediaPreviewPage({
    Key? key,
    required this.files,
    required this.mediaType,
  }) : super(key: key);

  @override
  State<TakenMediaPreviewPage> createState() => _TakenMediaPreviewPageState();
}

class _TakenMediaPreviewPageState extends State<TakenMediaPreviewPage> {
  final TextEditingController _descriptionController = TextEditingController();
// widget.mediaType == PostMediaType.video
  void peformAddPost() async {
    context.read<PostsBloc>().add(AddPostEvent(
        params: AddPostParams(
            imageFile: widget.files.first,
            description: _descriptionController.text.trim())));
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // POST FORM
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              Text(
                "Add a new post".hardcoded,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Expanded(
            child: BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {
                if (state is PostsNoInternetConnectionState) {
                  ToastUtils(context).showNoInternetConnectionToast();
                } else if (state is PostsErrorState) {
                  ToastUtils(context).showCustomToast(message: state.message);
                } else if (state is PostAddedSuccessState) {
                  ToastUtils(context).showCustomToast(
                      message: "Post added successfully".hardcoded);
                  context.go(Routes.posts);
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            if (state is PostsLoadingState)
                              const LinearProgressIndicator(),
                            if (state is PostsLoadingState)
                              const SizedBox(height: 10),
                            if (state is! PostsLoadingState) const Divider(),
                            Column(
                              mainAxisAlignment: widget.files.length > 1
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                widget.files.length > 1
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 471.sp,
                                        width: 378.sp,
                                        child: widget.mediaType ==
                                                PostMediaType.video
                                            ? Transform.scale(
                                                scale: .5.sp,
                                                child: SvgPicture.asset(
                                                  ImgAssets.videoPlayIconSVG,
                                                  width: 17.sp,
                                                  colorFilter: ColorFilter.mode(
                                                      Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .color!,
                                                      BlendMode.srcIn),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.sp),
                                                child: Image.file(
                                                  widget.files.first,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal:
                                          widget.files.length > 1 ? 8.sp : 0),
                                  child: SizedBox(
                                    width: 378.sp,
                                    child: TextField(
                                      controller: _descriptionController,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .color),
                                      decoration: InputDecoration(
                                          // fillColor: Colors.green,
                                          fillColor: Color(0xffF9F9FC),
                                          filled: true,
                                          hintText:
                                              "Make Description...".hardcoded,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(6.r))),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.files.length > 1)
                              CarouselSlider(
                                items: widget.files.map((file) {
                                  return Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 10.sp),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          7.sp,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              7.sp,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.sp),
                                          child: Image.file(
                                            File(file.path),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    height: MediaQuery.of(context).size.width,
                                    viewportFraction:
                                        widget.files.length > 1 ? .9 : 1,
                                    enableInfiniteScroll: false,
                                    autoPlay: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 5),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    onPageChanged: (i, r) {}),
                              ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<PostsBloc, PostsState>(
                      builder: (context, state) {
                        if (state is PostsLoadingState)
                          return const SizedBox(height: 10);

                        return SizedBox(
                          height: 58.sp,
                          width: MediaQuery.of(context).size.width - 40.sp,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () => peformAddPost(),
                            child: Text(
                              "Save & Share".hardcoded,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.sp),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.sp,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
