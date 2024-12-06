import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/resources/values_manager.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;

  const TimerWidget({Key? key, required this.duration}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration _currentDuration = const Duration(seconds: AppConstants.videoLength);

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentDuration = widget.duration - Duration(seconds: timer.tick);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Text(
        "${_currentDuration.inMinutes.toString()}:${_currentDuration.inSeconds.toString()}",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13.sp),
      ),
    );
  }
}
