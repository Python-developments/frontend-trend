import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/pages/sanad_profile.dart';
import 'package:frontend_trend/features/profile/presentation/widgets/single_profile_button.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../data/models/profile_model.dart';
import '../widgets/profile_posts.dart';
import '../../../../injection_container.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/toast_utils.dart';

import '../bloc/profile_bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  final int profileId;

  const ProfilePage({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Enables smooth scrolling
            child: BlocProvider(
              create: (context) => sl<GetProfileFollowingBloc>(),
              child: SanadProfile(
                profileId: profileId,
              ),
            )));
  }
}
