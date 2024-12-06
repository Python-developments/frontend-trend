import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'custom_cached_image.dart';
import '../../config/routes/app_routes.dart';
import '../../features/profile/data/models/profile_model.dart';
import 'logo_loader.dart';

class UsersListWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<ProfileModel> profiles;
  final bool isLoadingMore;
  final bool isFollowers;
  const UsersListWidget({
    Key? key,
    required this.scrollController,
    required this.profiles,
    this.isFollowers = false,
    required this.isLoadingMore,
  }) : super(key: key);

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(bottom: widget.isLoadingMore ? 60 : 12),
          controller: widget.scrollController,
          itemCount: widget.profiles.length,
          itemBuilder: (BuildContext context, int index) {
            final profile = widget.profiles[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: ListTile(
                horizontalTitleGap: 12.sp,
                dense: true,
                title: GestureDetector(
                  onTap: () {
                    context.push(Routes.profileDetails(profile.id));
                  },
                  child: Text(
                    profile.username,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                leading: CustomCachedImageWidget(
                    onTap: () {
                      context.push(Routes.profileDetails(profile.id));
                    },
                    size: 40.sp,
                    imageUrl: profile.avatar),
                trailing: InkWell(
                  onTap: () {
                    context.push(Routes.profileDetails(profile.id));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.sp,
                    width: 120.sp,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.sp)),
                    child: Text(
                      "Go to Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.isLoadingMore)
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
  }
}
