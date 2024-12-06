import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_trend/features/posts/data/models/post_model.dart';

Reaction<String> getDefaultReaction(String? reactionValue) {
  Reaction<String> reaction;
  switch (reactionValue) {
    case "like":
      reaction = Reaction<String>(
        value: 'like',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/like.svg',
        ),
        icon: buildReactionsIcon(
          'images/like.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    case "love":
      reaction = Reaction<String>(
        value: 'love',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/love.svg',
        ),
        icon: buildReactionsIcon(
          'images/love.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    case "haha":
      reaction = Reaction<String>(
        value: 'haha',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/haha.svg',
        ),
        icon: buildReactionsIcon(
          'images/haha.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    case "wow":
      reaction = Reaction<String>(
        value: 'wow',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/wow.svg',
        ),
        icon: buildReactionsIcon(
          'images/wow.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    case "crying":
      reaction = Reaction<String>(
        value: 'crying',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/crying.svg',
        ),
        icon: buildReactionsIcon(
          'images/crying.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    case "angry":
      reaction = Reaction<String>(
        value: 'angry',
        title: _buildEmojiTitle(
          '',
        ),
        previewIcon: _buildEmojiPreviewIcon(
          'images/angry.svg',
        ),
        icon: buildReactionsIcon(
          'images/angry.svg',
          const Text(
            '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
      break;
    default:
      reaction = Reaction<String>(
        value: 'like',
        icon: buildReactionsIcon(
            "assets/icons/single_post/like_empty.svg",
            const Text(
              '',
              style: TextStyle(height: 0.5, color: Color(0xff999EB2)),
            ),
            Color(0xff999EB2)),
      );
  }

  return reaction;
}

Reaction<String> defaultInitialReaction = Reaction<String>(
  value: 'remove',
  icon: buildReactionsIcon(
      "assets/icons/single_post/like_empty.svg",
      const Text(
        '',
        style: TextStyle(height: 0.5, color: Color(0xff999EB2)),
      ),
      Color(0xff999EB2)),
);

final List<Reaction<String>> reactions = [
  Reaction<String>(
    value: 'like',
    title: _buildEmojiTitle(
      '',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/like.svg',
    ),
    icon: buildReactionsIcon(
      'images/like.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  Reaction<String>(
    value: 'love',
    title: _buildEmojiTitle(
      'love',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/love.svg',
    ),
    icon: buildReactionsIcon(
      'images/love.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  Reaction<String>(
    value: 'haha',
    title: _buildEmojiTitle(
      'haha',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/haha.svg',
    ),
    icon: buildReactionsIcon(
      'images/haha.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  Reaction<String>(
    value: 'wow',
    title: _buildEmojiTitle(
      'wow',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/wow.svg',
    ),
    icon: buildReactionsIcon(
      'images/wow.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  Reaction<String>(
    value: 'crying',
    title: _buildEmojiTitle(
      'crying',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/crying.svg',
    ),
    icon: buildReactionsIcon(
      'images/crying.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  Reaction<String>(
    value: 'angry',
    title: _buildEmojiTitle(
      'angry',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'images/angry.svg',
    ),
    icon: buildReactionsIcon(
      'images/angry.svg',
      const Text(
        '',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    ),
  ),
];

Widget _buildFlagPreviewIcon(String path, String text) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 7.5),
      Image.asset(path, height: 30),
    ],
  );
}

Widget _buildEmojiTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.75),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildEmojiPreviewIcon(String path) {
  return SvgPicture.asset(path);
}

Widget _buildFlagIcon(String path) {
  return Image.asset(path);
}

Widget buildReactionsIcon(String path, Text text, [Color? color]) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        path.split('.').last == "svg"
            ? SvgPicture.asset(
                path,
                height: 20,
                color: color,
              )
            : Image.asset(
                path,
                height: 20,
                color: color,
              ),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}
