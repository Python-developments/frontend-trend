import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../data/models/vlog_model.dart';
import '../../../../../core/utils/toast_utils.dart';
import '../vlogs_bloc/vlogs_bloc.dart';

Future<dynamic> showConfirmDeleteVlogDialog(
    BuildContext context, VlogModel vlog, VlogsBloc bloc) async {
  return await showDialog(
    context: context,
    builder: (buildContext) {
      return AlertDialog(
        title: Text(
          "Delete vlog".hardcoded,
          style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.displayLarge!.color),
        ),
        content: Text("Are you sure you want to delete this vlog?".hardcoded),
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
          BlocConsumer<VlogsBloc, VlogsState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is VlogsErrorState) {
                ToastUtils(context).showCustomToast(message: state.message);
              } else if (state is VlogsNoInternetConnectionState) {
                ToastUtils(context).showNoInternetConnectionToast();
              } else if (state is VlogDeletedSuccessState) {
                ToastUtils(context).showCustomToast(
                    message: "vlog deleted successfully".hardcoded);
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  if (state is! VlogsLoadingState) {
                    bloc.add(DeleteVlogEvent(vlogId: vlog.id));
                  }
                },
                child: state is VlogsLoadingState
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
