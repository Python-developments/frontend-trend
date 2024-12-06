import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/features/profile/presentation/pages/edit_profile.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({super.key});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  // Sample list of messages
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hello!", "isUser": true},
    {"text": "Hi there! How are you?", "isUser": false},
    {"text": "I'm good, thanks. What about you?", "isUser": true},
    {"text": "I'm doing well too, thank you!", "isUser": false},
  ];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({"text": _messageController.text.trim(), "isUser": true});
      });
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Remove default shadow
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.sp, // Adjust icon size
            ), // Back icon
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16, // Adjust size as needed
                backgroundImage:
                    AssetImage('assets/images/person.jpg'), // Avatar
              ),
              const SizedBox(width: 8),
              Text(
                'Octagon Company',
                style: TextStyle(
                  color: Colors.black, // Set text color
                  fontSize: 15.sp, // Adjust text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Height of the underline
            child: Container(
              color:
                  const Color.fromARGB(255, 0, 0, 0), // Color of the underline
              height: 0.2, // Thickness of the underline
            ),
          ),
        ),
        body: Stack(
          children: [
            // Background image and messages
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/background_chat.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.4), // Semi-transparent overlay
            ),
            Padding(
              padding:
                  EdgeInsets.only(bottom: 60.h), // Leave space for input field
              child: ListView.builder(
                reverse: true, // Show latest messages at the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Align(
                    alignment: message["isUser"]
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: message["isUser"]
                            ? const Color.fromARGB(255, 136, 244, 139)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                          bottomLeft: message["isUser"]
                              ? Radius.circular(12.r)
                              : Radius.zero,
                          bottomRight: message["isUser"]
                              ? Radius.zero
                              : Radius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        message["text"],
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input field container at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.grey, // Gray border color
                    width: 0.2, // Border width
                  ),
                ),
                child: Container(
                  // Adjusted height for better spacing
                  color:
                      Colors.grey[200], // Gray background for the input field
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w), // Adjusted padding
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SvgPicture.asset(
                          'assets/icons/camera.svg',
                          height: 18.h, // Adjusted icon size
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          // height: 37.h,
                          child: TextField(
                            minLines: 1,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: _messageController,
                            textAlignVertical: TextAlignVertical
                                .center, // Align text vertically
                            cursorColor:
                                Colors.lightGreen, // Light green cursor color
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            // maxLines: 1, // Restrict to a single line
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15.w,
                              ), // Adjust padding
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Gray border color
                                    width: 0.4,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Gray border color
                                    width: 0.4,
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Gray border color
                                    width: 0.4,
                                  )),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      Container(
                        height: 24.h,
                        width: 24.h, // Make width equal to height for a circle
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 136, 244, 139), // Light green send button
                          shape: BoxShape.circle, // Make the container circular
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            size: 14.sp, // Adjusted icon size
                          ),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
