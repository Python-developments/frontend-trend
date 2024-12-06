// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:frontend_trend/core/utils/entities/paged_list.dart';
// import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
// import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
// import 'package:frontend_trend/features/profile/presentation/bloc/block_user_cubit/block_user_cubit.dart';
// import '../../../../config/locale/app_localizations.dart';
// import '../../../../core/utils/toast_utils.dart';

// class GetAllBlocksPage extends StatefulWidget {
//   const GetAllBlocksPage();

//   @override
//   State<GetAllBlocksPage> createState() => _BlocksPageState();
// }

// class _BlocksPageState extends State<GetAllBlocksPage> {
//   void _getAllBlocks() {
//     context.read<BlockUserCubit>().getAllBlockList(context);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getAllBlocks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("BlockList".hardcoded),
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               size: 18.sp,
//             ),
//           ),
//         ),
//         body: BlocConsumer<BlockUserCubit, BlockUserState>(
//           bloc: context.read<BlockUserCubit>(),
//           listener: (mainContext, state) {
//             if (state is BlockUserErrorState) {
//               ToastUtils(mainContext).showCustomToast(message: state.message);
//             } else if (state is BlockUserNoInternetConnectionState) {
//               ToastUtils(mainContext).showNoInternetConnectionToast();
//             } else if (state is BlockUserSuccessState) {
//               ToastUtils(mainContext).showCustomToast(
//                   message: "user blocked successfully".hardcoded);
//               Navigator.pop(mainContext, true);
//             }
//           },
//           builder: (context, state) {
//             if (state is BlockListLoadingState) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.black,
//                 ),
//               );
//             }
//             if (state is BlockListLoadedState) {
//               PagedList<ProfileModel> users = state.users;

//               return users.items.isEmpty
//                   ? Center(
//                       child: Text("Block List Is Empty"),
//                     )
//                   : ListView.builder(
//                       itemCount: users.items.length,
//                       itemBuilder: (context, index) {
//                         ProfileModel user = users.items[index];
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: 8.sp),
//                           child: ListTile(
//                             horizontalTitleGap: 12.sp,
//                             dense: true,
//                             title: GestureDetector(
//                               onTap: () {},
//                               child: Text(
//                                 user.username,
//                                 style: TextStyle(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .displayLarge
//                                         ?.color,
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                             ),
//                             leading: CustomCachedImageWidget(
//                                 onTap: () {},
//                                 size: 40.sp,
//                                 imageUrl: user.avatar),
//                             trailing: InkWell(
//                               onTap: () {
//                                 context
//                                     .read<BlockUserCubit>()
//                                     .performUnBlockUser(user.id, context);
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: 30.sp,
//                                 width: 120.sp,
//                                 decoration: BoxDecoration(
//                                     color: Colors.black,
//                                     borderRadius: BorderRadius.circular(10.sp)),
//                                 child: state is BlockUserLoadingState
//                                     ? Center(
//                                         child: CircularProgressIndicator(
//                                           color: Colors.white,
//                                         ),
//                                       )
//                                     : Text(
//                                         "UnBlock",
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         );
//                       });
//             }
//             return SizedBox();
//           },
//         ));
//   }
// }
