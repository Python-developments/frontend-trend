import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/post_model.dart';

class PostUsernameAndDescription extends StatefulWidget {
  final PostModel post;
  const PostUsernameAndDescription({Key? key, required this.post})
      : super(key: key);

  @override
  State<PostUsernameAndDescription> createState() =>
      _PostUsernameAndDescriptionState();
}

class _PostUsernameAndDescriptionState
    extends State<PostUsernameAndDescription> {
  List<TextSpan> buildDescriptionText(bool isArabic) {
    final description = widget.post.content;
    final RegExp exp = RegExp(r'\B#\w\w+');
    final Iterable<Match> matches = exp.allMatches(description);

    final List<TextSpan> textSpans = [];
    int previousEnd = 0;

    for (Match match in matches) {
      final String hashtag = match.group(0)!;
      final int start = match.start;
      final int end = match.end;

      if (start > previousEnd) {
        textSpans.add(TextSpan(
            text: description.substring(previousEnd, start),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: isArabic ? "sfarabic" : "Inter",
              // height: 1.3.sp,
            )));
      }

      textSpans.add(TextSpan(
        text: hashtag,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 1.3.sp,
          color: Theme.of(context).primaryColor,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {},
      ));

      previousEnd = end;
    }

    if (previousEnd < description.length) {
      textSpans.add(TextSpan(
          text: description.substring(previousEnd),
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.5.sp,
            fontFamily: isArabic ? "sfarabic" : "Inter",
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.displayLarge!.color!,
          )));
    }

    return textSpans;
  }

  bool isArabic(String text) {
    // A simple check to see if any character is within the Arabic Unicode block
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabicPost = isArabic(widget.post.content);
    return widget.post.content.isEmpty
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      ...buildDescriptionText(isArabicPost),
                    ],
                  ),
                  textAlign: isArabicPost ? TextAlign.right : TextAlign.left,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 15.sp),
              ],
            ),
          );
  }
}
