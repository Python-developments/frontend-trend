// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/core/resources/assets_manager.dart';
import 'package:frontend_trend/core/widgets/custom_tile.dart';
import 'package:frontend_trend/core/widgets/logo_loader.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/utils/delete_post_dialog.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/utils/modal_sheet_utils.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../injection_container.dart';
import '../../../../profile/presentation/widgets/utils/confirm_block_user_dialog.dart';
import '../../../data/models/post_model.dart';

class SinglePostModal extends StatefulWidget {
  final PostModel post;
  final BuildContext mainContext;
  const SinglePostModal(
      {super.key, required this.mainContext, required this.post});

  @override
  State<SinglePostModal> createState() => _SinglePostModalState();
}

class _SinglePostModalState extends State<SinglePostModal> {
  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        sl<SharedPref>().account!.id == widget.post.customUserId;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 15.sp),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.sp)),
        child: Column(
          children: [
            if (isCurrentUser)
              CustomTileWidget(
                iconIAssetUrl: ImgAssets.trashIconSVG,
                showTrailing: false,
                assetColor: kRedColor,
                assetSize: 20.sp,
                title: "Delete".hardcoded,
                onTap: () async {
                  final result = await showConfirmDeletePostDialog(
                      context, widget.post, context.read<PostsBloc>());
                  if (result != null && result) {
                    Navigator.pop(context);
                  }
                },
                titleColor: kRedColor,
              ),
            if (!isCurrentUser)
              BlocConsumer<PostsBloc, PostsState>(
                listener: (context, state) {
                  if (state is PostHidedSuccessState) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return CustomTileWidget(
                    iconIAssetUrl: ImgAssets.hideIconSVG,
                    showTrailing: state is HidePostLoadingState,
                    trailing: LogoLoader(
                      size: 12.sp,
                    ),
                    assetSize: 20.sp,
                    title: "Hide".hardcoded,
                    onTap: () async {
                      context
                          .read<PostsBloc>()
                          .add(HidePostEvent(postId: widget.post.id));
                    },
                  );
                },
              ),
            if (!isCurrentUser)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                ),
              ),
            if (!isCurrentUser)
              CustomTileWidget(
                iconIAssetUrl: ImgAssets.blockIconSVG,
                showTrailing: false,
                assetColor: kRedColor,
                assetSize: 20.sp,
                title: "Block user".hardcoded,
                onTap: () async {
                  final result = await showConfirmBlockUserDialog(
                    widget.mainContext,
                    widget.post.customUserId,
                  );
                  if (result != null && result) {
                    Navigator.pop(context);
                  }
                },
                titleColor: kRedColor,
              ),
          ],
        ),
      ),
    );
  }
}

void showPostModal(BuildContext context, PostModel post) {
  ModalSheetUtils(context).showCustomModalSheet(
      child: SinglePostModal(
        post: post,
        mainContext: context,
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "".hardcoded,
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
      removeHeader: true,
      takeJustNeededSize: true);
}
