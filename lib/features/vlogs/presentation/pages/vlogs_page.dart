import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../bloc/vlogs_bloc/vlogs_bloc.dart';
import '../widgets/single_vlog_widget.dart';

class VlogsPage extends StatefulWidget {
  const VlogsPage({super.key});

  @override
  State<VlogsPage> createState() => _VlogsPageState();
}

class _VlogsPageState extends State<VlogsPage> {
  late PaginationParam _paginationParams;
  int page = 1;

  void _getAllVlogs() {
    context
        .read<VlogsBloc>()
        .add(GetAllVlogsEvent(params: (_paginationParams..page = 1)));
  }

  late PageController _pageController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    if (context.read<VlogsBloc>().state.vlogs.isEmpty) {
      _getAllVlogs();
    }

    _pageController = PageController(
      initialPage: currentPageIndex,
      viewportFraction: 1.0,
    );
    _pageController.addListener(_pageChangeListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pageChangeListener() {
    final bloc = context.read<VlogsBloc>();
    final totalVlogs = bloc.state.vlogs.length;

    setState(() {
      currentPageIndex = _pageController.page!.toInt();
    });

    if (currentPageIndex == totalVlogs - 2 &&
        bloc.state.canLoadMore &&
        !bloc.isLoading) {
      _loadMoreContent();
    }
  }

  void _loadMoreContent() {
    final bloc = context.read<VlogsBloc>();
    bloc.add(GetAllVlogsEvent(
      params: _paginationParams..page = _paginationParams.page + 1,
    ));
    page = _paginationParams.page + 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VlogsBloc, VlogsState>(
        listener: (context, state) {
          if (state is VlogsNoInternetConnectionState) {
            ToastUtils(context).showNoInternetConnectionToast();
          } else if (state is VlogsErrorState) {
            ToastUtils(context).showCustomToast(message: state.message);
          }
        },
        builder: (context, state) {
          if (state is VlogsLoadedState || state.vlogs.isNotEmpty) {
            // bool isLoadingMore = (page != 1 &&
            //     state.canLoadMore &&
            //     (context.read<VlogsBloc>().isLoading));
            return Stack(
              children: [
                PageView.builder(
                  itemCount: state.vlogs.length,
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return SingleVlogWidget(vlog: state.vlogs[index]);
                  },
                ),
                // if (isLoadingMore)
                //   const Positioned(
                //     bottom: 20,
                //     left: 0,
                //     right: 0,
                //     child: Center(child: CircularProgressIndicator()),
                //   ),
              ],
            );
          } else if (state is VlogsErrorState) {
            return MyErrorWidget(message: state.message, onRetry: _getAllVlogs);
          } else if (state is VlogsNoInternetConnectionState) {
            return NoInternetConnectionWidget(onRetry: _getAllVlogs);
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
