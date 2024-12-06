// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/core/resources/assets_manager.dart';
import 'package:frontend_trend/core/widgets/custom_tile.dart';
import 'package:frontend_trend/features/vlogs/presentation/bloc/utils/delete_vlog_dialog.dart';
import 'package:frontend_trend/features/vlogs/presentation/bloc/vlogs_bloc/vlogs_bloc.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/utils/modal_sheet_utils.dart';
import '../../data/models/vlog_model.dart';

class SingleVlogModal extends StatefulWidget {
  final VlogModel vlog;
  final VlogsBloc vlogsBloc;
  const SingleVlogModal({
    Key? key,
    required this.vlog,
    required this.vlogsBloc,
  }) : super(key: key);

  @override
  State<SingleVlogModal> createState() => _SingleVlogModalState();
}

class _SingleVlogModalState extends State<SingleVlogModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTileWidget(
          iconIAssetUrl: ImgAssets.trashIconSVG,
          showTrailing: false,
          assetColor: kRedColor,
          assetSize: 20.sp,
          title: "Delete".hardcoded,
          onTap: () async {
            final result = await showConfirmDeleteVlogDialog(
                context, widget.vlog, widget.vlogsBloc);
            if (result != null && result) {
              Navigator.pop(context);
            }
          },
          titleColor: kRedColor,
        ),
      ],
    );
  }
}

void showVlogModal(BuildContext context, VlogsBloc vlogsBloc, VlogModel vlog) {
  ModalSheetUtils(context).showCustomModalSheet(
      child: SingleVlogModal(
        vlog: vlog,
        vlogsBloc: vlogsBloc,
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
