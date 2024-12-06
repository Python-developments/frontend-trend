import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:frontend_trend/features/profile/presentation/pages/edit_bio.dart';
import 'package:frontend_trend/injection_container.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/utils/media_picker_utils.dart';
import '../../../../core/widgets/overlay_loading_page.dart';
import '../../data/models/profile_form_data.dart';
import '../../data/models/profile_model.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileModel profile;
  const EditProfilePage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  String? avatarFileUrl;
  String? backgroundImageFileUrl;
  @override
  void initState() {
    super.initState();
    _bioController.text = widget.profile.bio;
    changeProfileBio(widget.profile.bio);
  }

  _editProfile() {
    context.read<ProfileBloc>().add(
          UpdateProfileInfoEv(
              formData: ProfileFormData(
                  profileId: widget.profile.id,
                  avatar: avatarFileUrl == null ? null : File(avatarFileUrl!),
                  backgroundImage: backgroundImageFileUrl == null
                      ? null
                      : File(backgroundImageFileUrl!),
                  bio: _bioController.text.trim()),
              context: context),
        );
  }

  Future<void> _pickAvatarImage(BuildContext context) async {
    final pickedImage =
        await MediaPickerUtils().showImageSourceModalThenPick(context);
    if (pickedImage != null) {
      avatarFileUrl = pickedImage.path;
      setState(() {});
    }
  }

  String bio = "";

  changeProfileBio(String newBio) {
    bio = newBio;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final isLoading = state is ProfileLoadingState;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: OverlayLoadingPage(
            isLoading: isLoading,
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 60.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // changeProfileBio("newBio");
                        Navigator.pop(context, bio != widget.profile.bio);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.sp,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            size: 15.sp,
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              _editProfile();
                            },
                      child: Text(
                        "Save".hardcoded,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 45.sp,
                            backgroundColor: Colors.white,
                            child: CustomCachedImageWidget(
                                addBorder: false,
                                size: 100.sp,
                                radius: 100.sp,
                                fileUrl: avatarFileUrl,
                                imageUrl: widget.profile.avatar),
                          ),
                          Positioned(
                            bottom: 3.sp,
                            left: 0.sp,
                            child: GestureDetector(
                              onTap: () async {
                                await _pickAvatarImage(context);
                              },
                              child: CircleAvatar(
                                radius: 12.sp,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  "assets/icons/single_post/content.png",
                                  height: 15.sp,
                                  width: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/new_user.svg",
                              height: 14.sp,
                            ),
                            SizedBox(
                              width: 10.sp,
                            ),
                            Text(
                              "Personal Informations",
                              style: TextStyle(
                                  height: 0.7,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.sp)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "Username",
                              value: widget.profile.username,
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "First Name",
                              value: widget.profile.fName.isEmpty
                                  ? "-"
                                  : widget.profile.fName,
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "Last Name",
                              value: widget.profile.lName.isEmpty
                                  ? "-"
                                  : widget.profile.lName,
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            InkWell(
                              onTap: () {
                                Get.to(MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                          create: (context) =>
                                              sl<CurrentUserCubit>()),
                                      BlocProvider(
                                          create: (context) =>
                                              sl<ProfileBloc>())
                                    ],
                                    child: EditBio(
                                      profile: state.profile!,
                                      changedBio: changeProfileBio,
                                    )));
                                // context.go(Routes.editBio,
                                //     extra: {"profile": state.profile});
                              },
                              child: ProfileWidget(
                                icon: "assets/icons/profile/new/user2.svg",
                                title: "Bio",
                                value: (bio.isEmpty ? '-' : bio),
                              ),
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "Phone",
                              value: widget.profile.phone.isEmpty
                                  ? '-'
                                  : widget.profile.phone,
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "Location",
                              value: widget.profile.location.isEmpty
                                  ? '-'
                                  : widget.profile.location,
                            ),
                            SizedBox(
                                width: 250,
                                child: Divider(
                                  height: 1,
                                  thickness: 0.2,
                                )),
                            ProfileWidget(
                              icon: "assets/icons/profile/new/user2.svg",
                              title: "Email",
                              value: state.profile?.mail ?? '',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/new_user.svg",
                              height: 14.sp,
                            ),
                            SizedBox(
                              width: 10.sp,
                            ),
                            Text(
                              "Personal Informations",
                              style: TextStyle(
                                  height: 0.7,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.sp)),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                GoRouter.of(context).push(Routes.blockPage);
                              },
                              child: ProfileWidget(
                                icon: "assets/icons/profile/new/user2.svg",
                                title: "BlockList",
                                value: '',
                                showDivider: false,
                              ),
                            ),
                            SizedBox(
                                child: Divider(
                              height: 1,
                              thickness: 0.2,
                            )),
                            InkWell(
                              onTap: () {
                                sl<SharedPref>().logout();
                                GoRouter.of(context).go(Routes.login);
                              },
                              child: ProfileWidget(
                                icon: "assets/icons/profile/new/user2.svg",
                                title: "Logout",
                                value: '',
                              ),
                            ),
                            SizedBox(
                                child: Divider(
                              height: 1,
                              thickness: 0.2,
                            )),
                            InkWell(
                              onTap: () async {
                                sl<SharedPref>().logout();
                                await Future.delayed(Duration(seconds: 2));
                                ToastUtils(context).showCustomToast(
                                  message:
                                      "Your Request has been sent, Request will be cancked if you login again to the account",
                                  iconData: Icons.error_outline,
                                );
                                GoRouter.of(context).go(Routes.login);
                              },
                              child: ProfileWidget(
                                icon: "assets/icons/profile/new/user2.svg",
                                title: "Delete Account",
                                value: '',
                                showDivider: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }

  Future<void> _pickBackgroundImage(BuildContext context) async {
    final pickedImage =
        await MediaPickerUtils().showImageSourceModalThenPick(context);
    if (pickedImage != null) {
      backgroundImageFileUrl = pickedImage.path;
      setState(() {});
    }
  }
}

class ProfileWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final bool showDivider;

  const ProfileWidget(
      {super.key,
      required this.icon,
      required this.title,
      this.showDivider = false,
      required this.value});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    // Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: Colors.grey,
                    ),
                  ],
                ),
                showDivider
                    ? SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
