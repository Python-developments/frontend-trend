import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/features/posts/presentation/pages/custom_listview.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../widgets/posts_shimmer.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../bloc/posts_bloc/posts_bloc.dart';
import '../widgets/single_post_widgets/single_post_widget.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllPosts() {
    context
        .read<PostsBloc>()
        .add(GetAllPostsEvent(params: (_paginationParams..page = 1)));
  }

  void _fetchPostsNextPage() {
    final bloc = context.read<PostsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetAllPostsEvent(
        params: _paginationParams..page = _paginationParams.page + 1,
      ));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    if (context.read<PostsBloc>().state.posts.isEmpty) {
      _getAllPosts();
    }

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final offset = _scrollController.offset;
      final outOfRange = _scrollController.position.outOfRange;
      if (offset >= maxScrollExtent && !outOfRange) {
        _fetchPostsNextPage();
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
        surfaceTintColor: Colors.white,
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
      body: BlocConsumer<PostsBloc, PostsState>(
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
            return Column(
              children: [
                Divider(
                  color:
                      const Color.fromARGB(255, 243, 243, 243), // Divider color
                  thickness: 1, // Thickness of the divider
                  height: 1, // Height of the divider widget
                ),
                Expanded(
                  child: Stack(
                    children: [
                      CustomListview(
                        isLoading: isLoadingMore,
                        posts: state.posts,
                        scrollController: _scrollController,
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
                  ),
                ),
              ],
            );
          } else if (state is PostsErrorState) {
            return MyErrorWidget(message: state.message, onRetry: _getAllPosts);
          } else if (state is PostsNoInternetConnectionState) {
            return NoInternetConnectionWidget(onRetry: _getAllPosts);
          }
          // return const PostsShimmer();
          return const PostsShimmer();
        },
      ),
    ));
  }
}
