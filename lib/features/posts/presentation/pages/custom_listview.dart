import 'package:flutter/material.dart';
import 'package:frontend_trend/features/posts/data/models/post_model.dart';
import 'package:frontend_trend/features/posts/presentation/widgets/single_post_widgets/single_post_widget.dart';

class CustomListview extends StatefulWidget {
  List<PostModel> posts;
  bool isLoading;
  ScrollController scrollController;
  CustomListview(
      {required this.posts,
      required this.isLoading,
      required this.scrollController});

  @override
  State<CustomListview> createState() => _CustomListviewState();
}

class _CustomListviewState extends State<CustomListview> {
  bool isZooming = false;
  triggerZooming(bool x) {
    isZooming = x;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      controller: widget.scrollController,
      padding: EdgeInsets.only(bottom: widget.isLoading ? 60 : 12),
      physics:
          isZooming ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
      itemCount: widget.posts.length,
      itemBuilder: (BuildContext context, int index) {
        return SinglePostWidget(
          post: widget.posts[index],
          function: triggerZooming,
        );
      },
    );
  }
}
