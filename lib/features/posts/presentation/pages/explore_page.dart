import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../../../core/widgets/no_search_result_widget.dart';
import '../../../../core/widgets/post_square_media.dart';
import '../../data/models/post_model.dart';
import '../bloc/posts_bloc/posts_bloc.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';

  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllPosts() {
    context
        .read<PostsBloc>()
        .add(GetAllPostsEvent(params: _paginationParams..page = 1));
  }

  void _fetchPostsNextPage() {
    final bloc = context.read<PostsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetAllPostsEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          emitLoading: false));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _fetchPostsNextPage();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        _fetchPostsNextPage();
      }
    });
  }

  List<PostModel> _filterPosts(List<PostModel> posts) {
    if (_searchQuery.isEmpty) {
      return posts;
    } else {
      return posts.where((post) {
        return post.username.contains(_searchQuery) ||
            post.content.contains(_searchQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 45.h), // Add padding for the status bar
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 33.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (v) {
                  setState(() {
                    _searchQuery = v;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        fit: BoxFit.contain,
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            height: 200.h,
            width: double
                .infinity, // Ensures the image takes the full width of the screen
            child: Image.asset(
              'assets/images/football.jpg',
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
            ),
          ),

          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Explore Posts',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child:
                BlocConsumer<PostsBloc, PostsState>(listener: (context, state) {
              if (state is PostsNoInternetConnectionState) {
                ToastUtils(context).showNoInternetConnectionToast();
              } else if (state is PostsErrorState) {
                ToastUtils(context).showCustomToast(message: state.message);
              }
            }, builder: (context, state) {
              if (state is PostsLoadedState || state.posts.isNotEmpty) {
                bool isLoadingMore = (page != 1 &&
                    state.canLoadMore &&
                    (context.read<PostsBloc>().isLoading));
                final filteredPosts = _filterPosts(state.posts);
                if (filteredPosts.isEmpty) {
                  return const NoSearchResultWidget();
                }
                return GridView.builder(
                  padding:
                      EdgeInsets.zero, // Ensure no extra padding is applied
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of images per row
                    crossAxisSpacing: 1.w, // Horizontal spacing
                    mainAxisSpacing: 1.h, // Vertical spacing
                    childAspectRatio: 1, // Ensures square cells
                  ),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.go(Routes.postDetails(filteredPosts[index].id),
                            extra: {"post": filteredPosts[index]});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            0), // Optional: Add rounded corners
                        child: CustomCachedImageWidget(
                          imageUrl: filteredPosts[index].image,
                          size: 10,
                          radius: 0,
                          // Ensures the image covers the cell without gaps
                        ),
                      ),
                    );
                  },
                );
              } else if (state is PostsErrorState) {
                return MyErrorWidget(
                  message: state.message,
                  onRetry: _getAllPosts,
                );
              } else if (state is PostsNoInternetConnectionState) {
                return NoInternetConnectionWidget(
                  onRetry: _getAllPosts,
                );
              }
              return const Center(child: LogoLoader());
            }),
          ),
        ],
      ),
    );
  }
}
/*

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';

  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllPosts() {
    context
        .read<PostsBloc>()
        .add(GetAllPostsEvent(params: _paginationParams..page = 1));
  }

  void _fetchPostsNextPage() {
    final bloc = context.read<PostsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetAllPostsEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          emitLoading: false));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _fetchPostsNextPage();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        _fetchPostsNextPage();
      }
    });
  }

  List<PostModel> _filterPosts(List<PostModel> posts) {
    if (_searchQuery.isEmpty) {
      return posts;
    } else {
      return posts.where((post) {
        return post.username.contains(_searchQuery) ||
            post.content.contains(_searchQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.sp,
                ),
                SvgPicture.asset("assets/icons/profile/back.svg"),
                SizedBox(
                  width: 20.sp,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.sp),
                      prefixIconConstraints:
                          BoxConstraints(maxHeight: 20.sp, maxWidth: 30.sp),
                      prefixIcon: Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          SvgPicture.asset(
                            "assets/icons/bottom_nav_bar/search.svg",
                            height: 20.sp,
                            width: 20.sp,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.sp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.sp)),
                      labelStyle: TextStyle(
                        color: Color(0xffF8F8F8),
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: Color(0xffF8F8F8),
                      hintText: "   Search".hardcoded,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  width: 20.sp,
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              color: Color(0xffF5F5F7),
              indent: 0,
              height: 0,
            ),
            SizedBox(
              height: 10.h,
            ),

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 12.sp),
            //   child: Row(
            //     children: [
            //       Text(
            //         "Trending Tags",
            //         style:
            //             TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            //       ),
            //       Spacer(),
            //       Text(
            //         "See All ",
            //         style:
            //             TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            //       ),
            //       SvgPicture.asset("assets/icons/arrow.svg")
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       CategoryWidget("All"),
            //       CategoryWidget("FootBall", "assets/images/football.jpg"),
            //       CategoryWidget("BasketBall", "assets/images/basketball.jpg"),
            //       CategoryWidget("BaseBall", "assets/images/baseball.jpg"),
            //       CategoryWidget("FootBall", "assets/images/football.jpg"),
            //       CategoryWidget("BasketBall", "assets/images/basketball.jpg"),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.sp),
              child: Row(children: [
                Text(
                  "Explore Posts",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                Spacer(),
              ]),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: BlocConsumer<PostsBloc, PostsState>(
                listener: (context, state) {
                  if (state is PostsNoInternetConnectionState) {
                    ToastUtils(context).showNoInternetConnectionToast();
                  } else if (state is PostsErrorState) {
                    ToastUtils(context).showCustomToast(message: state.message);
                  }
                },
                builder: (context, state) {
                  if (state is PostsLoadedState || state.posts.isNotEmpty) {
                    bool isLoadingMore = (page != 1 &&
                        state.canLoadMore &&
                        (context.read<PostsBloc>().isLoading));
                    final filteredPosts = _filterPosts(state.posts);
                    if (filteredPosts.isEmpty) {
                      return const NoSearchResultWidget();
                    }
                    return Stack(
                      children: [
                        GridView.builder(
                          controller: _scrollController,
                          padding:
                              EdgeInsets.only(bottom: isLoadingMore ? 60 : 12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.sp,
                            crossAxisSpacing: 5.sp,
                            // repeatPattern: QuiltedGridRepeatPattern.same,
                            // pattern: [
                            //   const QuiltedGridTile(2, 2),
                            //   for (var _ in filteredPosts)
                            //     const QuiltedGridTile(1, 1),
                            // ],
                          ),
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                context.go(
                                    Routes.postDetails(filteredPosts[index].id),
                                    extra: {"post": filteredPosts[index]});
                              },
                              child: CustomSquarePostMediaWidget(
                                imageUrl: filteredPosts[index].image,
                              ),
                            );
                          },
                        ),
                        if (isLoadingMore)
                          Positioned(
                            bottom: 5.sp,
                            left: 0,
                            right: 0,
                            child: Center(
                                child: LogoLoader(
                              size: 20.sp,
                            )),
                          ),
                      ],
                    );
                  } else if (state is PostsErrorState) {
                    return MyErrorWidget(
                      message: state.message,
                      onRetry: _getAllPosts,
                    );
                  } else if (state is PostsNoInternetConnectionState) {
                    return NoInternetConnectionWidget(
                      onRetry: _getAllPosts,
                    );
                  }
                  return const Center(child: LogoLoader());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/