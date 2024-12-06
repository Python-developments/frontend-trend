import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/features/profile/data/models/profile_form_data.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';

class EditBio extends StatefulWidget {
  final ProfileModel profile;
  final Function changedBio;
  const EditBio({required this.profile, required this.changedBio});
  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  TextEditingController _bioController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bioController.text = widget.profile.bio;
  }

  _editProfile() {
    context.read<ProfileBloc>().add(
          UpdateProfileInfoEv(
              formData: ProfileFormData(
                  profileId: widget.profile.id,
                  avatar: null,
                  backgroundImage: null,
                  bio: _bioController.text.trim()),
              context: context),
        );
    widget.changedBio(_bioController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      final isLoading = state is ProfileLoadingState;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 60.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.sp,
                      ),
                      Text(
                        "Cancel",
                      ),
                      SizedBox(
                        width: 20.sp,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Bio",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _editProfile();
                        },
                  child: Text(
                    "Save".hardcoded,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            Divider(color: const Color.fromARGB(255, 243, 243, 243)),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    // Dynamically limit the number of lines
                    final lines = text.split('\n');
                    if (lines.length > 5) {
                      _bioController.text = lines.take(5).join('\n');
                      _bioController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _bioController.text.length));
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        80), // Limit to 80 characters
                    // FilteringTextInputFormatter.allow(
                    //     RegExp(r'[^\n]*')), // Prevent newlines beyond maxLines
                  ],
                  controller: _bioController,
                  maxLines: 5,
                  maxLength: 80,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4))),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)))),
                ))
          ],
        ),
      );
    });
  }
}
