import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../data/models/post_model.dart';
import '../posts_bloc/posts_bloc.dart';
import '../../../../../core/utils/toast_utils.dart';

Future<dynamic> showConfirmDeletePostDialog(
    BuildContext context, PostModel post, PostsBloc bloc) async {
  return await showDialog(
    context: context,
    builder: (buildContext) {
      return AlertDialog(
        title: Text(
          "Delete post".hardcoded,
          style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.displayLarge!.color),
        ),
        content: Text("Are you sure you want to delete this post?".hardcoded),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              "Cancel".hardcoded,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          BlocConsumer<PostsBloc, PostsState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostsErrorState) {
                ToastUtils(context).showCustomToast(message: state.message);
              } else if (state is PostsNoInternetConnectionState) {
                ToastUtils(context).showNoInternetConnectionToast();
              } else if (state is PostDeletedSuccessState) {
                ToastUtils(context).showCustomToast(
                    message: "Post deleted successfully".hardcoded);
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (state is! PostsLoadingState) {
                    bloc.add(DeletePostEvent(postId: post.id));
                  }
                },
                child: state is PostsLoadingState
                    ? SizedBox(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(strokeWidth: 2.sp),
                      )
                    : Text(
                        "Delete".hardcoded,
                        style: const TextStyle(
                          color: kRedColor,
                        ),
                      ),
              );
            },
          ),
        ],
      );
    },
  );
}
