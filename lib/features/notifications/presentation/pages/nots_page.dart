// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:frontend_trend/config/routes/app_routes.dart';
// import 'package:frontend_trend/core/resources/assets_manager.dart';
// import 'package:frontend_trend/core/utils/toast_utils.dart';
// import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
// import 'package:frontend_trend/core/widgets/my_error_widget.dart';
// import 'package:frontend_trend/core/widgets/no_internet_connection_widget.dart';
// import 'package:frontend_trend/features/notifications/presentation/bloc/not_bloc/not_bloc.dart';
// import 'package:frontend_trend/features/posts/presentation/widgets/posts_shimmer.dart';
// import 'package:go_router/go_router.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   State<NotificationsPage> createState() => _PostsPageState();
// }

// class _PostsPageState extends State<NotificationsPage> {
//   final ScrollController _scrollController = ScrollController();
//   int page = 1;

//   void _getAllNotifications() {
//     context.read<NotBloc>().add(GetAllNotsEvent());
//   }

//   void _fetchPostsNextPage() {
//     final bloc = context.read<NotBloc>();
//     if (!bloc.isLoading) {
//       bloc.add(GetAllNotsEvent());

//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (context.read<NotBloc>().state.nots.isEmpty) {
//       _getAllNotifications();
//     }

//     _scrollController.addListener(() {
//       final maxScrollExtent = _scrollController.position.maxScrollExtent;
//       final offset = _scrollController.offset;
//       final outOfRange = _scrollController.position.outOfRange;
//       if (offset >= maxScrollExtent && !outOfRange) {
//         _fetchPostsNextPage();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<NotBloc, NotState>(
//         listener: (context, state) {
//           if (state is NotsNoInternetConnectionState) {
//             ToastUtils(context).showNoInternetConnectionToast();
//           } else if (state is NotsErrorState) {
//             ToastUtils(context).showCustomToast(message: state.message);
//           }
//         },
//         builder: (context, state) {
//           if (state is NotsLoadedState || state.nots.isNotEmpty) {
//             return Container(
//               margin: EdgeInsets.symmetric(horizontal: 10.w),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 70.h,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 5.sp),
//                     child: Row(
//                       children: [
//                         // IconButton(
//                         //   icon: const Icon(Icons.arrow_back),
//                         //   onPressed: () {
//                         //     if (Navigator.canPop(context)) {
//                         //       Navigator.of(context).pop();
//                         //     }
//                         //   },
//                         // ),
//                         Text(
//                           "Notifications",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 15.sp),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.r,
//                   ),
//                   Divider(
//                     color: Color(0xffF5F5F7),
//                     indent: 0,
//                     height: 0,
//                   ),
//                   Expanded(
//                     child: Stack(
//                       children: [
//                         CustomScrollView(
//                             controller: _scrollController,
//                             slivers: [
//                               SliverToBoxAdapter(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.only(bottom: 12),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: state.nots.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return GestureDetector(
//                                       onTap: () async {
//                                         if (state
//                                                 .nots[index].notificationType ==
//                                             "follow") {
//                                           context.push(
//                                             Routes.profileDetails(state
//                                                     .nots[index].senderUserId ??
//                                                 0),
//                                           );
//                                         } else {
//                                           context.push(
//                                             Routes.postDetails(
//                                                 state.nots[index].postId ?? 0),
//                                           );
//                                         }
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsets.all(10.sp),
//                                         child: Row(
//                                           children: [
//                                             CustomCachedImageWidget(
//                                               onTap: () {
//                                                 context.push(
//                                                   Routes.postDetails(state
//                                                           .nots[index].postId ??
//                                                       0),
//                                                 );
//                                               },
//                                               addBorder: false,
//                                               size: 30.r,
//                                               imageUrl: state.nots[index]
//                                                       .senderAvatar ??
//                                                   '',
//                                             ),
//                                             SizedBox(width: 10.sp),

//                                             Text(
//                                               state.nots[index]
//                                                           .notificationType ==
//                                                       "reaction"
//                                                   ? '${state.nots[index].senderUsername} has put ${state.nots[index].reactionType} on your post'
//                                                   : '${state.nots[index].senderUsername} followed you',
//                                               style: TextStyle(
//                                                   fontFamily: "Inter",
//                                                   fontSize: 12.sp,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w400),
//                                             ),
//                                             SizedBox(
//                                               width: 5.w,
//                                             ),
//                                             // Icon(
//                                             //   Icons.verified,
//                                             //   color: Colors.blue,
//                                             //   size: 20.r,
//                                             // )
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             ]),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else if (state is NotsErrorState) {
//             return MyErrorWidget(
//                 message: state.message, onRetry: _getAllNotifications);
//           } else if (state is NotsNoInternetConnectionState) {
//             return NoInternetConnectionWidget(onRetry: _getAllNotifications);
//           }
//           // return const PostsShimmer();
//           return const PostsShimmer();
//         },
//       ),
//     );
//   }
// }
