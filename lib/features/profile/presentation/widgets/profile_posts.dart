import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/profile_posts_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/posts/presentation/pages/posts_page_profile.dart';
import '../../../../core/widgets/post_square_media.dart';
import '../../data/models/profile_model.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/logo_loader.dart';

class ProfilePostsWidget extends StatefulWidget {
  final ProfileModel profile;
  final bool isPost;
  final ScrollController scrollController;

  const ProfilePostsWidget(
      {Key? key,
      required this.profile,
      required this.isPost,
      required this.scrollController})
      : super(key: key);

  @override
  State<ProfilePostsWidget> createState() => _ProfilePostsWidgetState();
}

class _ProfilePostsWidgetState extends State<ProfilePostsWidget> {
  late PaginationParam _paginationParams;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);

    widget.scrollController.addListener(() {
      if (mounted) {
        if (widget.scrollController.offset >=
                widget.scrollController.position.maxScrollExtent &&
            !widget.scrollController.position.outOfRange) {
          if (widget.isPost) {
            _fetchPostsNextPage();
          }
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (widget.scrollController.hasClients &&
          widget.scrollController.position.maxScrollExtent <= 0) {
        if (widget.isPost) {
          _fetchPostsNextPage();
        }
      }
    });
  }

  void _fetchPostsNextPage() {
    final bloc = context.read<ProfileBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(FetchProfileInfoEv(
          context: context,
          emitLoading: false,
          params: _paginationParams..page = _paginationParams.page + 1,
          profileId: widget.profile.id));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profile.posts.items.isEmpty) return const SizedBox();
    return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
        itemCount: widget.profile.posts.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.push("/userposts", extra: {
                "index": index,
                "posts": widget.profile.posts.items,
                "userId": widget.profile.id
              });
            },
            child: CachedNetworkImage(
              imageUrl: widget.profile.posts.items[index].image,
              fit: BoxFit.cover,
            ),
          );
        });
  }
}
