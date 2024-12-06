import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import '../../../../../../config/locale/app_localizations.dart';
import '../../../../../../core/utils/entities/pagination_param.dart';
import '../../../../../../core/widgets/custom_cached_image.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../../core/widgets/logo_loader.dart';
import '../../../../../profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import '../../../../data/models/params/add_comment_params.dart';
import '../../../../data/models/post_model.dart';
import '../../../bloc/comments_bloc/comments_bloc.dart';
import '../../../../../../config/routes/app_routes.dart';
import '../../../../../../core/utils/modal_sheet_utils.dart';
import '../../../../../../core/utils/toast_utils.dart';
import '../../../../../../core/widgets/my_error_widget.dart';
import '../../../../../../core/widgets/no_internet_connection_widget.dart';
import '../../../../../../injection_container.dart';

class PostCommentsModalWidget extends StatefulWidget {
  final int postId;
  const PostCommentsModalWidget({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<PostCommentsModalWidget> createState() =>
      _PostCommentsModalWidgetState();
}

class _PostCommentsModalWidgetState extends State<PostCommentsModalWidget> {
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
          postId: widget.postId));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  void _getCommentsByPost() {
    context.read<CommentsBloc>().add(GetCommentsByPostEvent(
        params: _paginationParams..page = 1, postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state is CommentsNoInternetConnectionState) {
          ToastUtils(context).showNoInternetConnectionToast();
        } else if (state is CommentsErrorState) {
          ToastUtils(context).showCustomToast(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is CommentsLoadedState || state.comments.isNotEmpty) {
          bool isLoadingMore = (page != 1 &&
              state.canLoadMore &&
              (context.read<CommentsBloc>().isLoading));
          return Container(
            color: Colors.grey[100],
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    (MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 20.sp)),
            child: Column(
              children: [
                state.comments.isEmpty
                    ? Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text("No comments yet.".hardcoded),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Stack(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: isLoadingMore ? 60 : 12),
                                controller: context
                                    .read<CommentsBloc>()
                                    .scrollController,
                                itemCount: state.comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = state.comments[index];

                                  return ListTile(
                                    horizontalTitleGap: 12.sp,
                                    dense: true,
                                    isThreeLine: true,
                                    title: GestureDetector(
                                      onTap: () {
                                        context.pop();
                                        context.push(Routes.profileDetails(
                                            comment.commenterProfileId));
                                      },
                                      child: Text(
                                        comment.commenterName,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.color,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    subtitle: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.sp),
                                      child: Text(
                                        comment.content,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.color,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    leading: CustomCachedImageWidget(
                                        onTap: () {
                                          context.pop();
                                          context.push(Routes.profileDetails(
                                              comment.commenterProfileId));
                                        },
                                        size: 30.sp,
                                        imageUrl: comment.commenterAvatar),
                                  );
                                },
                              ),
                              if (isLoadingMore)
                                Positioned(
                                  bottom: 5.sp,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                      child: LogoLoader(
                                    size: 20.sp,
                                  )),
                                ),
                            ],
                          ),
                        ),
                      ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.sp)
                      .copyWith(top: 8.sp, bottom: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          log(context
                                  .read<CurrentUserCubit>()
                                  .state
                                  .user
                                  ?.avatar ??
                              "");
                        },
                        child: CustomCachedImageWidget(
                            size: 30.sp,
                            imageUrl: context
                                    .watch<CurrentUserCubit>()
                                    .state
                                    .user
                                    ?.avatar ??
                                ""),
                      ),
                      Gap(9.sp),
                      Expanded(
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: CustomTextFormField(
                            isFilled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(100)),
                            suffixIcon: state is CommentsLoadingState &&
                                    !isLoadingMore
                                ? Transform.scale(
                                    scale: .4.sp,
                                    child: const CircularProgressIndicator())
                                : null,
                            enabled:
                                state is! CommentsLoadingState || isLoadingMore,
                            controller:
                                context.read<CommentsBloc>().commentController,
                            hintText: "Add a comment".hardcoded,
                            onFieldSubmitted: (value) {
                              context.read<CommentsBloc>().add(AddCommentEvent(
                                  context: context,
                                  params: AddCommentParams(
                                    postId: widget.postId,
                                    comment: context
                                        .read<CommentsBloc>()
                                        .commentController
                                        .text
                                        .trim(),
                                  )));
                            },
                          ),
                        ),
                      ),
                      Gap(9.sp),
                      InkWell(
                        onTap: () {
                          context.read<CommentsBloc>().add(AddCommentEvent(
                              context: context,
                              params: AddCommentParams(
                                postId: widget.postId,
                                comment: context
                                    .read<CommentsBloc>()
                                    .commentController
                                    .text
                                    .trim(),
                              )));
                        },
                        child: Container(
                          height: 30.sp,
                          width: 30.sp,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          child: SvgPicture.asset(
                            "assets/icons/single_post/send.svg",
                            height: 15.sp,
                            width: 15.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (state is CommentsErrorState) {
          return MyErrorWidget(
              message: state.message, onRetry: _getCommentsByPost);
        } else if (state is CommentsNoInternetConnectionState) {
          return NoInternetConnectionWidget(onRetry: _getCommentsByPost);
        }
        return const LogoLoader();
      },
    );
  }
}

void showCommentsModal(BuildContext context, PostModel post) {
  ModalSheetUtils(context).showCustomModalSheet(
      color: Colors.grey[100],
      child: BlocProvider(
        create: (context) => sl<CommentsBloc>(),
        child: PostCommentsModalWidget(
          postId: post.id,
        ),
      ),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: SvgPicture.asset(
                  "assets/icons/single_post/bs_comments.svg",
                  color: Colors.transparent,
                )),
            BlocConsumer<PostsBloc, PostsState>(
                listener: (x, y) {},
                builder: (context, state) {
                  int index = state.posts.indexWhere((x) => x.id == post.id);
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Comments ".hardcoded,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff616977),
                          ),
                        ),
                        TextSpan(
                          text: state.posts[index].commentCount.toString(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1F2232)),
                        ),
                      ],
                    ),
                  );
                }),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: SvgPicture.asset(
                    "assets/icons/single_post/bs_comments.svg"))
          ],
        ),
      ),
      disableScroll: true,
      height: MediaQuery.of(context).size.height * 0.75);
}
