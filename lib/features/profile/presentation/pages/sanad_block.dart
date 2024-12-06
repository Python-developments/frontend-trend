import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/entities/paged_list.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/block_user_cubit/block_user_cubit.dart';

class GetAllBlocksPage extends StatefulWidget {
  @override
  State<GetAllBlocksPage> createState() => _GetAllBlocksPageState();
}

class _GetAllBlocksPageState extends State<GetAllBlocksPage> {
  void _getAllBlocks() {
    context.read<BlockUserCubit>().getAllBlockList(context);
  }

  @override
  void initState() {
    super.initState();
    _getAllBlocks();
  }

  PagedList<ProfileModel>? users;
  int deletedIndex = -1;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Blocked Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<BlockUserCubit, BlockUserState>(
          bloc: context.read<BlockUserCubit>(),
          listener: (mainContext, state) {
            if (state is BlockUserErrorState) {
              ToastUtils(mainContext).showCustomToast(message: state.message);
            } else if (state is BlockUserNoInternetConnectionState) {
              ToastUtils(mainContext).showNoInternetConnectionToast();
            } else if (state is BlockUserSuccessState) {
              ToastUtils(mainContext).showCustomToast(
                  message: "user blocked successfully".hardcoded);
              Navigator.pop(mainContext, true);
            } else if (state is BlockListLoadedState) {
              users = state.users;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is BlockListLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            if (users != null) {
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 65.w, right: 23.w),
                      child: Divider(
                        color: Colors.grey[300],
                      ),
                    );
                  },
                  itemCount: users!.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          radius: 20, // You can adjust the size
                          backgroundColor: Colors
                              .transparent, // Optional, remove background color
                          child: ClipOval(
                            child: CustomCachedImageWidget(
                              onTap: () {
                                context.push(Routes.profileDetails(
                                    users!.items[index].id));
                              },
                              imageUrl: users!.items[index].avatar,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: users!.items[index].username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            context.read<BlockUserCubit>().performUnBlockUser(
                                users!.items[index].id, context);
                            deletedIndex = index;
                            setState(() {});
                          },
                          child: Container(
                            height: 25.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 23, 173, 46),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: (state is BlockUserLoadingState &&
                                      index == deletedIndex)
                                  ? Container(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Unblock',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ));
                  });
            }
            return SizedBox();
          }),
    );
  }
}
