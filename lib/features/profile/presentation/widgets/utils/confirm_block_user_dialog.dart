import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/block_user_cubit/block_user_cubit.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/utils/toast_utils.dart';

Future<dynamic> showConfirmBlockUserDialog(
    BuildContext mainContext, int blockedUserId) async {
  return await showDialog(
    context: mainContext,
    builder: (buildContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Block user".hardcoded,
          style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(mainContext).textTheme.displayLarge!.color),
        ),
        content: Text("Are you sure you want to block this user?".hardcoded),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(mainContext).disabledColor,
            ),
            onPressed: () {
              Navigator.of(mainContext, rootNavigator: true).pop();
            },
            child: Text(
              "Cancel".hardcoded,
              style: TextStyle(color: Theme.of(mainContext).hintColor),
            ),
          ),
          BlocConsumer<BlockUserCubit, BlockUserState>(
            bloc: mainContext.read<BlockUserCubit>(),
            listener: (mainContext, state) {
              if (state is BlockUserErrorState) {
                ToastUtils(mainContext).showCustomToast(message: state.message);
              } else if (state is BlockUserNoInternetConnectionState) {
                ToastUtils(mainContext).showNoInternetConnectionToast();
              } else if (state is BlockUserSuccessState) {
                ToastUtils(mainContext).showCustomToast(
                    message: "user blocked successfully".hardcoded);
                Navigator.pop(mainContext, true);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (state is! BlockUserLoadingState) {
                    mainContext
                        .read<BlockUserCubit>()
                        .performBlockUser(blockedUserId, mainContext);
                  }
                },
                child: state is BlockUserLoadingState
                    ? SizedBox(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(strokeWidth: 2.sp),
                      )
                    : Text(
                        "Block".hardcoded,
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
