import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late PaginationParam _paginationParams;
  late ScrollController _scrollController;
  List<GlobalKey> _itemKeys = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    context.read<ProfilePostsBloc>().add(InitialocalReactionEvent(
        posts: widget.posts,
        user: context.read<CurrentUserCubit>().state.user));
    _scrollController = ScrollController();

    // Dynamically generate a unique GlobalKey for each post
    _itemKeys = List.generate(widget.posts.length, (_) => GlobalKey());

    // Ensure scrolling happens after layout
    _scrollToInitialIndex();
  }

  void _getAllPosts() {
    context
        .read<PostsBloc>()
        .add(GetAllPostsEvent(params: (_paginationParams..page = 1)));
  }

  void _scrollToInitialIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index >= 0 && widget.index < widget.posts.length) {
        final key = _itemKeys[widget.index];
        final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        log("widget position is ${key.currentContext}");
        if (renderBox != null) {
          // Calculate the position of the item relative to the screen
          final position = renderBox.localToGlobal(Offset.zero).dy;
          log("widget position is $position");
          // Dynamically calculate the AppBar height
          final appBarHeight = AppBar().preferredSize.height;

          // Account for the safe area (top padding for devices with notches or system UI elements)
          final safeAreaTop = MediaQuery.of(context).padding.top;

          // Optional: Add screen padding if needed
          final screenPadding = 13.0.sp; // Adjust this as per your design

          // Adjust the scroll position to ensure the entire item is visible
          final adjustedPosition =
              position - appBarHeight - safeAreaTop - screenPadding;

          // Ensure the scroll position is valid (not negative)

          if (adjustedPosition >= 0 &&
              widget.index != widget.posts.length - 1) {
            _scrollController.jumpTo(adjustedPosition);
          } else if (widget.index == widget.posts.length - 1) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        }
      }
    });
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
              List<PostModel> posts = state.posts;

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                    children: List.generate(posts.length, (index) {
                  return Container(
                    key: _itemKeys[index], // Unique key for each item
                    child: SinglePostWidget(
                      isprofilePost: true,
                      profilePosts: widget.posts,
                      key: _itemKeys[index], // Unique key for each item
                      post: posts[index],
                      function: () {},
                    ),
                  );
                })),
              );
            } else if (state is PostsErrorState) {
              return MyErrorWidget(
                  message: state.message, onRetry: _getAllPosts);
            } else if (state is PostsNoInternetConnectionState) {
              return NoInternetConnectionWidget(onRetry: _getAllPosts);
            }

            // Default shimmer state
            return const PostsShimmer();
          },
        ),
      ),
    );
  }
}
