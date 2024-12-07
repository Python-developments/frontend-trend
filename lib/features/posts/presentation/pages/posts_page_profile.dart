import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/profile_posts_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:frontend_trend/core/widgets/loading_widget.dart';
import 'package:frontend_trend/features/posts/data/models/post_model.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/full_logo.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../widgets/posts_shimmer.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../bloc/posts_bloc/posts_bloc.dart';
import '../widgets/single_post_widgets/single_post_widget.dart';

class PostsUserPage extends StatefulWidget {
  final List<PostModel> posts;
  final int index;
  final int userId;
  const PostsUserPage(
      {super.key,
      required this.posts,
      required this.index,
      required this.userId});

  @override
  State<PostsUserPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsUserPage> {
  int page = 1;
  FlutterListViewController controller = FlutterListViewController();
  @override
  void initState() {
    super.initState();
    controller.sliverController.jumpToIndex(widget.index);
    context.read<ProfilePostsBloc>().add(InitialocalReactionEvent(
        posts: widget.posts,
        user: context.read<CurrentUserCubit>().state.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'T  R  E  N  D',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: BlocConsumer<ProfilePostsBloc, PostsState>(
          listener: (context, state) {
            if (state is PostsNoInternetConnectionState) {
              ToastUtils(context).showNoInternetConnectionToast();
            } else if (state is PostsErrorState) {
              ToastUtils(context).showCustomToast(message: state.message);
            }
          },
          builder: (context, state) {
            if (state is ProfilePostsLoadedState) {
              List<PostModel> posts = widget.posts;
              return ScrollablePositionedList.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) => SinglePostWidget(
                        isprofilePost: true,
                        profilePosts: widget.posts,
                        post: posts[index],
                        function: () {},
                      ),
                  initialScrollIndex: widget.index);
            } else if (state is PostsErrorState) {
              return MyErrorWidget(message: state.message, onRetry: () {});
            } else if (state is PostsNoInternetConnectionState) {
              return NoInternetConnectionWidget(onRetry: () {});
            }

            // Default shimmer state
            return const PostsShimmer();
          },
        ),
      ),
    );
  }
}
