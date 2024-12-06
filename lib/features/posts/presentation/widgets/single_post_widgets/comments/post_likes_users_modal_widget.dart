import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/locale/app_localizations.dart';
import '../../../../../../core/utils/entities/pagination_param.dart';
import '../../../../../../core/widgets/logo_loader.dart';
import '../../../../../../core/widgets/users_list_widget.dart';
import '../../../../data/models/post_model.dart';
import '../../../../../../core/utils/modal_sheet_utils.dart';
import '../../../../../../core/utils/toast_utils.dart';
import '../../../../../../core/widgets/my_error_widget.dart';
import '../../../../../../core/widgets/no_internet_connection_widget.dart';
import '../../../../../../injection_container.dart';
import '../../../bloc/get_likes_users_by_post_bloc/get_likes_users_by_post_bloc.dart';

class PostLikesUsersModalWidget extends StatefulWidget {
  final int postId;
  const PostLikesUsersModalWidget({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<PostLikesUsersModalWidget> createState() =>
      _PostLikesUsersModalWidgetState();
}

class _PostLikesUsersModalWidgetState extends State<PostLikesUsersModalWidget> {
  final ScrollController _scrollController = ScrollController();
  late PaginationParam _paginationParams;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    _getGetLikesUsersByPostByPost();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _fetchGetLikesUsersByPostNextPage();
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        _fetchGetLikesUsersByPostNextPage();
      }
    });
  }

  void _fetchGetLikesUsersByPostNextPage() {
    final bloc = context.read<GetLikesUsersByPostBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(FetchLikesUsersByPostEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          postId: widget.postId));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  void _getGetLikesUsersByPostByPost() {
    context.read<GetLikesUsersByPostBloc>().add(FetchLikesUsersByPostEvent(
        params: _paginationParams..page = 1, postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetLikesUsersByPostBloc, GetLikesUsersByPostState>(
      listener: (context, state) {
        if (state is GetLikesUsersByPostNoInternetConnectionState) {
          ToastUtils(context).showNoInternetConnectionToast();
        } else if (state is GetLikesUsersByPostErrorState) {
          ToastUtils(context).showCustomToast(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is GetLikesUsersByPostLoadedState || state.users.isNotEmpty) {
          bool isLoadingMore = (page != 1 &&
              state.canLoadMore &&
              (context.read<GetLikesUsersByPostBloc>().isLoading));
          return UsersListWidget(
              scrollController: _scrollController,
              profiles: state.users,
              isLoadingMore: isLoadingMore);
        } else if (state is GetLikesUsersByPostErrorState) {
          return MyErrorWidget(
              message: state.message, onRetry: _getGetLikesUsersByPostByPost);
        } else if (state is GetLikesUsersByPostNoInternetConnectionState) {
          return NoInternetConnectionWidget(
              onRetry: _getGetLikesUsersByPostByPost);
        }
        return const LogoLoader();
      },
    );
  }
}

void showGetLikesUsersByPostModal(BuildContext context, PostModel post) {
  ModalSheetUtils(context).showCustomModalSheet(
      child: BlocProvider(
        create: (context) => sl<GetLikesUsersByPostBloc>(),
        child: PostLikesUsersModalWidget(
          postId: post.id,
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Likes".hardcoded,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff616977),
              ),
            ),
          ],
        ),
      ),
      disableScroll: true,
      height: MediaQuery.sizeOf(context).height * .6.sp);
}
