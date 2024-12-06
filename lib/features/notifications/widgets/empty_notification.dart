import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          child: Image.asset('assets/icons/mailbox2.png'),
        ),
        SizedBox(height: 10.h),
        Text('No Notifications yet!',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'You will be notified here when you have new notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 133, 133, 133),
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
