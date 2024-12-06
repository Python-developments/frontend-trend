import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_trend/core/widgets/loading_widget.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../bloc/posts_bloc/posts_bloc.dart';
import '../widgets/single_post_widgets/single_post_widget.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';

class SinglePostPage extends StatefulWidget {
  final int postId;
  const SinglePostPage({super.key, required this.postId});

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  @override
  void initState() {
    super.initState();
    _getPostDetails();
  }

  _getPostDetails() {
    context.read<PostsBloc>().add(FetchSinglePostEvent(postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state.currentPost?.id == widget.postId) {
            return Stack(
              children: [
                SinglePostWidget(
                  post: state.currentPost!,
                  function: (x) {},
                ),
                if (state is PostsLoadingState)
                  const Positioned.fill(
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  )
              ],
            );
          } else if (state is PostsErrorState) {
            return MyErrorWidget(
                message: state.message, onRetry: _getPostDetails);
          } else if (state is PostsNoInternetConnectionState) {
            return NoInternetConnectionWidget(onRetry: _getPostDetails);
          }
          return const Center(child: LogoLoader());
        },
      ),
    );
  }
}
