import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../../../core/widgets/custom_cached_image.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/logo_loader.dart';
import '../../../../profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import '../../bloc/vlogs_bloc/vlogs_bloc.dart';
import '../../../../../../config/routes/app_routes.dart';
import '../../../../../../core/utils/modal_sheet_utils.dart';
import '../../../../../../core/utils/toast_utils.dart';
import '../../../../../../core/widgets/my_error_widget.dart';
import '../../../../../../core/widgets/no_internet_connection_widget.dart';
import '../../../../../../injection_container.dart';
import '../../../data/models/params/add_vlog_comment_params.dart';
import '../../../data/models/vlog_model.dart';
import '../../bloc/vlog_comments_bloc/vlog_comments_bloc.dart';

class VlogCommentsModalWidget extends StatefulWidget {
  final VlogsBloc vlogsBloc;
  final int vlogId;
  const VlogCommentsModalWidget({
    Key? key,
    required this.vlogId,
    required this.vlogsBloc,
  }) : super(key: key);

  @override
  State<VlogCommentsModalWidget> createState() =>
      _VlogCommentsModalWidgetState();
}

class _VlogCommentsModalWidgetState extends State<VlogCommentsModalWidget> {
  late PaginationParam _paginationParams;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    _getVlogCommentsByVlog();
    final bloc = context.read<VlogCommentsBloc>();

    super.initState();
    bloc.scrollController.addListener(() {
      if (bloc.scrollController.offset >=
              bloc.scrollController.position.maxScrollExtent &&
          !bloc.scrollController.position.outOfRange) {
        _fetchVlogCommentsNextPage();
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (bloc.scrollController.hasClients &&
          bloc.scrollController.position.maxScrollExtent <= 0) {
        _fetchVlogCommentsNextPage();
      }
    });
  }

  @override
  void dispose() {
    context.read<VlogCommentsBloc>().scrollController.dispose();
    context.read<VlogCommentsBloc>().commentController.dispose();
    super.dispose();
  }

  void _fetchVlogCommentsNextPage() {
    final bloc = context.read<VlogCommentsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetCommentsByVlogEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          vlogId: widget.vlogId));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  void _getVlogCommentsByVlog() {
    context.read<VlogCommentsBloc>().add(GetCommentsByVlogEvent(
        params: _paginationParams..page = 1, vlogId: widget.vlogId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VlogCommentsBloc, VlogCommentsState>(
      listener: (context, state) {
        if (state is VlogCommentsNoInternetConnectionState) {
          ToastUtils(context).showNoInternetConnectionToast();
        } else if (state is VlogCommentsErrorState) {
          ToastUtils(context).showCustomToast(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is VlogCommentsLoadedState || state.comments.isNotEmpty) {
          bool isLoadingMore = (page != 1 &&
              state.canLoadMore &&
              (context.read<VlogCommentsBloc>().isLoading));
          return Column(
            children: [
              state.comments.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text("No comments yet.".hardcoded),
                      ),
                    )
                  : Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.only(
                                bottom: isLoadingMore ? 60 : 12),
                            controller: context
                                .read<VlogCommentsBloc>()
                                .scrollController,
                            itemCount: state.comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = state.comments[index];

                              return ListTile(
                                horizontalTitleGap: 12.sp,
                                dense: true,
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
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                subtitle: Text(
                                  comment.content,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                leading: CustomCachedImageWidget(
                                    onTap: () {
                                      context.pop();
                                      context.push(Routes.profileDetails(
                                          comment.commenterProfileId));
                                    },
                                    size: 40.sp,
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
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.sp).copyWith(top: 8.sp),
                child: Row(
                  children: [
                    CustomCachedImageWidget(
                        size: 48.sp,
                        imageUrl: context
                                .watch<CurrentUserCubit>()
                                .state
                                .user
                                ?.avatar ??
                            ""),
                    Gap(12.sp),
                    Expanded(
                      child: CustomTextFormField(
                        suffixIcon:
                            state is VlogCommentsLoadingState && !isLoadingMore
                                ? Transform.scale(
                                    scale: .4.sp,
                                    child: const CircularProgressIndicator())
                                : null,
                        enabled:
                            state is! VlogCommentsLoadingState || isLoadingMore,
                        controller:
                            context.read<VlogCommentsBloc>().commentController,
                        hintText: "Add a comment".hardcoded,
                        onFieldSubmitted: (value) {
                          context.read<VlogCommentsBloc>().add(AddCommentEvent(
                              context: context,
                              vlogsVloc: widget.vlogsBloc,
                              params: AddVlogCommentParams(
                                vlogId: widget.vlogId,
                                comment: context
                                    .read<VlogCommentsBloc>()
                                    .commentController
                                    .text
                                    .trim(),
                              )));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is VlogCommentsErrorState) {
          return MyErrorWidget(
              message: state.message, onRetry: _getVlogCommentsByVlog);
        } else if (state is VlogCommentsNoInternetConnectionState) {
          return NoInternetConnectionWidget(onRetry: _getVlogCommentsByVlog);
        }
        return const LogoLoader();
      },
    );
  }
}

void showVlogCommentsModal(
    VlogsBloc vlogsBloc, BuildContext context, VlogModel post) {
  ModalSheetUtils(context).showCustomModalSheet(
      child: BlocProvider(
        create: (context) => sl<VlogCommentsBloc>(),
        child: VlogCommentsModalWidget(
          vlogId: post.id,
          vlogsBloc: vlogsBloc,
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Comments".hardcoded,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff616977),
              ),
            ),
          ],
        ),
      ),
      disableScroll: true,
      height: MediaQuery.sizeOf(context).height * .6.sp);
}
