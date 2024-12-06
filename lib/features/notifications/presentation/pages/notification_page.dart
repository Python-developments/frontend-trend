import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/my_error_widget.dart';
import 'package:frontend_trend/core/widgets/no_internet_connection_widget.dart';
import 'package:frontend_trend/features/notifications/presentation/bloc/not_bloc/not_bloc.dart';
import 'package:frontend_trend/features/notifications/widgets/empty_notification.dart';
import 'package:frontend_trend/features/notifications/widgets/notification_item.dart';
import 'package:frontend_trend/features/posts/presentation/widgets/posts_shimmer.dart';
import 'package:frontend_trend/injection_container.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllNotifications() {
    context.read<NotBloc>().add(GetAllNotsEvent());
  }

  void _fetchPostsNextPage() {
    final bloc = context.read<NotBloc>();
    if (!bloc.isLoading) {
      bloc.add(GetAllNotsEvent());

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    if (context.read<NotBloc>().state.nots.isEmpty) {
      _getAllNotifications();
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
    return BlocConsumer<NotBloc, NotState>(listener: (context, state) {
      if (state is NotsNoInternetConnectionState) {
        ToastUtils(context).showNoInternetConnectionToast();
      } else if (state is NotsErrorState) {
        ToastUtils(context).showCustomToast(message: state.message);
      }
    }, builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: (state is NotsLoadedState || state.nots.isNotEmpty)
              ? state.nots.isEmpty
                  ? EmptyNotification()
                  : Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.nots.length,
                            itemBuilder: (context, index) {
                              bool isCurrentUser =
                                  sl<SharedPref>().account!.id ==
                                      state.nots[index].senderUserId;
                              if (isCurrentUser) {
                                return SizedBox.shrink();
                              }
                              return NotificationItem(state.nots[index]);
                            },
                          ),
                        ),
                      ],
                    )
              : (state is NotsErrorState)
                  ? MyErrorWidget(
                      message: state.message, onRetry: _getAllNotifications)
                  : (state is NotsNoInternetConnectionState)
                      ? NoInternetConnectionWidget(
                          onRetry: _getAllNotifications)
                      : PostsShimmer());
    });
  }
}
