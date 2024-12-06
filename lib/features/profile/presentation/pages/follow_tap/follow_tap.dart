import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/pages/follow_tap/follower_tab.dart';
import 'package:frontend_trend/features/profile/presentation/pages/follow_tap/following_tab.dart';
import 'package:frontend_trend/injection_container.dart';

class FollowTabs extends StatefulWidget {
  final int profileId;
  final String name;
  final int tabIndex;
  const FollowTabs(
      {super.key,
      required this.profileId,
      required this.name,
      required this.tabIndex});

  @override
  State<FollowTabs> createState() => _FollowTabsState();
}

class _FollowTabsState extends State<FollowTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);
  }

  bool unFollowTriggered = false;
  setunFollowTriggered(bool x) {
    unFollowTriggered = x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: InkWell(
            onTap: () {
              Get.back(result: unFollowTriggered);
            },
            child: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
        bottom: TabBar(
          dividerColor: Colors.grey.withOpacity(0.2),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FollowerTab(
            profileId: widget.profileId,
          ),
          BlocProvider(
            create: (context) => sl<ProfileBloc>(),
            child: FolowingTab(
              profileId: widget.profileId,
              function: setunFollowTriggered,
            ),
          )
        ],
      ),
    );
  }
}
