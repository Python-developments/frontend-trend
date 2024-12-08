import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/entities/pagination_param.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/authentication/data/models/user_model.dart';
import 'package:frontend_trend/features/posts/data/models/params/add_comment_params.dart';
import 'package:frontend_trend/features/posts/data/models/post_model.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/comments_bloc/comments_bloc.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:go_router/go_router.dart';

class SanadCommentsSheet extends StatefulWidget {
  final UserModel? user;
  final PostModel post;
  SanadCommentsSheet(this.post, this.user);

  @override
  State<SanadCommentsSheet> createState() => _SanadCommentsSheetState();
}

class _SanadCommentsSheetState extends State<SanadCommentsSheet> {
  TextEditingController _controller = TextEditingController();
  late PaginationParam _paginationParams;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    _getCommentsByPost();
    final bloc = context.read<CommentsBloc>();

    super.initState();
    bloc.scrollController.addListener(() {
      if (bloc.scrollController.offset >=
              bloc.scrollController.position.maxScrollExtent &&
          !bloc.scrollController.position.outOfRange) {
        _fetchCommentsNextPage();
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (bloc.scrollController.hasClients &&
          bloc.scrollController.position.maxScrollExtent <= 0) {
        _fetchCommentsNextPage();
      }
    });
  }

  @override
  void dispose() {
    context.read<CommentsBloc>().scrollController.dispose();
    context.read<CommentsBloc>().commentController.dispose();
    super.dispose();
  }

  void _fetchCommentsNextPage() {
    final bloc = context.read<CommentsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetCommentsByPostEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          postId: widget.post.id));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  void _getCommentsByPost() {
    context.read<CommentsBloc>().add(GetCommentsByPostEvent(
        params: _paginationParams..page = 1, postId: widget.post.id));
  }

  String getTimeAgoShort(DateTime createdAt) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d'; // e.g. "1 d"
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h'; // e.g. "5 h"
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m'; // e.g. "10 m"
    } else {
      return '${difference.inSeconds}s'; // e.g. "30 s"
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocConsumer<CommentsBloc, CommentsState>(
        listener: (context, state) {
      if (state is CommentsNoInternetConnectionState) {
        ToastUtils(context).showNoInternetConnectionToast();
      } else if (state is CommentsErrorState) {
        ToastUtils(context).showCustomToast(message: state.message);
      }
    }, builder: (context, state) {
      if (state is CommentsLoadedState || state.comments.isNotEmpty) {
        bool isLoadingMore = (page != 1 &&
            state.canLoadMore &&
            (context.read<CommentsBloc>().isLoading));
      }
      return SizedBox(
        height:
            MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Column(
          children: [
            // Comments header
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'Comments',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6.h),
            Divider(
              color: Colors.grey,
              thickness: 0.1,
              height: 5.h,
            ),
            SizedBox(height: 6.h),

            // Comments list
            Expanded(
              child: state.comments.isEmpty
                  ? Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("No comments yet.".hardcoded),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: context.read<CommentsBloc>().scrollController,
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                  context.push(Routes.profileDetails(
                                      comment.commenterProfileId));
                                },
                                child: CustomCachedImageWidget(
                                  imageUrl: comment.commenterAvatar,
                                  size: 32,
                                  // Example image
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Username and Comment
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.commenterName,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      comment.content,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                getTimeAgoShort(comment.createdAt),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Thin grey line above text field
            Divider(
              color: Colors.grey,
              thickness: 0.1,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, bottom: 16.h, top: 8.h),
              child: Row(
                children: [
                  // Avatar on the left of input field
                  InkWell(
                    onTap: () {
                      log(context
                              .read<CurrentUserCubit>()
                              .state
                              .user
                              ?.id
                              .toString() ??
                          '');
                    },
                    child: CustomCachedImageWidget(
                        size: 30.h, imageUrl: widget.user?.avatar ?? ''),
                  ),
                  SizedBox(width: 10.w),

                  // Input field
                  Expanded(
                    child: Container(
                      height: 35.h, // Reduce height to make the input compact
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 234, 234, 234),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller:
                            context.read<CommentsBloc>().commentController,
                        onSubmitted: (value) {
                          context.read<CommentsBloc>().add(AddCommentEvent(
                              context: context,
                              params: AddCommentParams(
                                postId: widget.post.id,
                                comment: context
                                    .read<CommentsBloc>()
                                    .commentController
                                    .text
                                    .trim(),
                              )));
                        },
                        decoration: InputDecoration(
                          hintText: "comment...",
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none, // Remove default borders
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, // Reduce vertical padding
                            horizontal:
                                16.w, // Add consistent horizontal padding
                          ),
                        ),
                        style: TextStyle(
                          fontSize:
                              12.sp, // Match text size with compact height
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Send Button
                  IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context.read<CommentsBloc>().add(AddCommentEvent(
                            context: context,
                            params: AddCommentParams(
                              postId: widget.post.id,
                              comment: context
                                  .read<CommentsBloc>()
                                  .commentController
                                  .text
                                  .trim(),
                            )));
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
