import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/resources/assets_manager.dart';
import '../bloc/vlogs_bloc/vlogs_bloc.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/models/params/add_vlog_params.dart';

class TakenVlogPreviewPage extends StatefulWidget {
  final List<File> files;
  const TakenVlogPreviewPage({
    Key? key,
    required this.files,
  }) : super(key: key);

  @override
  State<TakenVlogPreviewPage> createState() => _TakenVlogPreviewPageState();
}

class _TakenVlogPreviewPageState extends State<TakenVlogPreviewPage> {
  final TextEditingController _descriptionController = TextEditingController();

  void peformAddVlog() async {
    context.read<VlogsBloc>().add(AddVlogEvent(
        params: AddVlogParams(
            videoFile: widget.files.first,
            description: _descriptionController.text.trim())));
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.files.first)
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  bool isPlayed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "New vlog".hardcoded,
        ),
        centerTitle: false,
        actions: <Widget>[
          BlocBuilder<VlogsBloc, VlogsState>(
            builder: (context, state) {
              if (state is VlogsLoadingState) return const SizedBox();
              return TextButton(
                onPressed: () => peformAddVlog(),
                child: Text(
                  "Post".hardcoded,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
              );
            },
          )
        ],
      ),
      // POST FORM
      body: BlocConsumer<VlogsBloc, VlogsState>(
        listener: (context, state) {
          if (state is VlogsNoInternetConnectionState) {
            ToastUtils(context).showNoInternetConnectionToast();
          } else if (state is VlogsErrorState) {
            ToastUtils(context).showCustomToast(message: state.message);
          } else if (state is VlogAddedSuccessState) {
            ToastUtils(context)
                .showCustomToast(message: "Vlog added successfully".hardcoded);
            context.go(Routes.vlogs);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      if (state is VlogsLoadingState)
                        const LinearProgressIndicator(),
                      if (state is VlogsLoadingState)
                        const SizedBox(height: 10),
                      if (state is! VlogsLoadingState) const Divider(),
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
                                  child: videoPlayerController
                                          .value.isInitialized
                                      ? InkWell(
                                          onTap: () {
                                            if (isPlayed) {
                                              videoPlayerController.pause();
                                            } else {
                                              videoPlayerController.play();
                                            }
                                            isPlayed = !isPlayed;
                                            setState(() {});
                                          },
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.sp),
                                                child: VideoPlayer(
                                                    videoPlayerController),
                                              ),
                                              Positioned.fill(
                                                  child: Center(
                                                      child: Icon(
                                                isPlayed
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 50.sp,
                                                color: Colors.white,
                                              )))
                                            ],
                                          ))
                                      : CircularProgressIndicator()),
                          SizedBox(
                            height: 10.sp,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: widget.files.length > 1 ? 8.sp : 0),
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
                                    hintText: "Make Description...".hardcoded,
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
                              padding: EdgeInsetsDirectional.only(end: 10.sp),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 7.sp,
                                height:
                                    MediaQuery.of(context).size.width * 7.sp,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.sp),
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
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              onPageChanged: (i, r) {}),
                        ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<VlogsBloc, VlogsState>(
                builder: (context, state) {
                  if (state is VlogsLoadingState) return const SizedBox();
                  return SizedBox(
                    height: 58.sp,
                    width: MediaQuery.of(context).size.width - 40.sp,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () => peformAddVlog(),
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
    );
  }
}
