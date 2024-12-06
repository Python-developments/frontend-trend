import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/features/profile/data/models/profile_form_data.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';

class ProfileValues {
  final String fname;
  final String lname;
  final String phone;
  final String location;
  final String bio;

  ProfileValues(
      {required this.fname,
      required this.lname,
      required this.phone,
      required this.location,
      required this.bio});
}

class EditBio extends StatefulWidget {
  final ProfileModel profile;
  final Function changedBio;
  final int lineCount;
  final int charsCount;
  final String title;
  final String value;
  final ProfileValues profileValues;
  const EditBio({
    required this.profile,
    required this.changedBio,
    required this.lineCount,
    required this.charsCount,
    required this.title,
    required this.value,
    required this.profileValues,
  });
  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  TextEditingController _bioController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _bioController.text = widget.value;
  }

  _editProfile() {
    context.read<ProfileBloc>().add(
          UpdateProfileInfoEv(
              formData: ProfileFormData(
                  profileId: widget.profile.id,
                  avatar: null,
                  backgroundImage: null,
                  bio: widget.title.toLowerCase() == "bio"
                      ? _bioController.text.trim()
                      : widget.profileValues.bio,
                  lName: widget.title.toLowerCase() == "last name"
                      ? _bioController.text.trim()
                      : widget.profileValues.lname,
                  fName: widget.title.toLowerCase() == "first name"
                      ? _bioController.text.trim()
                      : widget.profileValues.fname,
                  location: widget.title.toLowerCase() == "location"
                      ? _bioController.text.trim()
                      : widget.profileValues.location,
                  phone: widget.title.toLowerCase() == "phone"
                      ? _bioController.text.trim()
                      : widget.profileValues.phone),
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
                  widget.title,
                  textAlign: TextAlign.center,
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
                        widget.charsCount), // Limit to 80 characters
                    // FilteringTextInputFormatter.allow(
                    //     RegExp(r'[^\n]*')), // Prevent newlines beyond maxLines
                  ],
                  controller: _bioController,
                  maxLines: widget.lineCount,
                  maxLength: widget.charsCount,
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
