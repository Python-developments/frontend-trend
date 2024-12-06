import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/features/chat/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ListUsersChatState();
}

class _ListUsersChatState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            // GoRouter.of(context).go(Routes.initialPage);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: SvgPicture.asset('assets/icons/chat_arrow_back.svg'),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: SvgPicture.asset('assets/icons/chat_3dots.svg'),
          ),
        ],
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 52, 41, 41),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: ListView(
          children: [
            Column(
              children: [
                ListTile(
                  onTap: () {
                    Get.to(ChatUser());
                  },
                  leading: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage('assets/images/desert.jpg'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between name and time
                    children: [
                      Text(
                        'afro',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 52, 41, 41),
                        ),
                      ),
                      Text(
                        '10:30 AM',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      SvgPicture.asset('assets/icons/send_and_read.svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Hey, how are you?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 0.5,
                  indent: 90.w, // Align divider with text
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage('assets/images/desert.jpg'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between name and time
                    children: [
                      Text(
                        'afro',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 52, 41, 41),
                        ),
                      ),
                      Text(
                        'Sunday',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      SvgPicture.asset('assets/icons/no_read.svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Hey, how are you?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 0.5,
                  indent: 90.w, // Align divider with text
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage('assets/images/desert.jpg'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between name and time
                    children: [
                      Text(
                        'afro',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 52, 41, 41),
                        ),
                      ),
                      Text(
                        'Saturday',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      SvgPicture.asset('assets/icons/one_check.svg'),
                      SizedBox(width: 5.w),
                      Text(
                        'Hey, how are you?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 0.5,
                  indent: 90.w, // Align divider with text
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage('assets/images/desert.jpg'),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between name and time
                    children: [
                      Text(
                        'afro',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 52, 41, 41),
                        ),
                      ),
                      Text(
                        '11/5/2024',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Hey, how are you?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 84, 84, 84),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 0.5,
                  indent: 90.w, // Align divider with text
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
