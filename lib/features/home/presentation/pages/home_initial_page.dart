// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';

import '../../../../core/widgets/logo_loader.dart';

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});

  @override
  State<HomeInitialPage> createState() => _HomeInitialPageState();
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  _goToPostsPage() async {
    await Future.delayed(const Duration(seconds: 1));
    context.go(Routes.posts);
  }

  @override
  void initState() {
    _goToPostsPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LogoLoader(size: 80)),
    );
  }
}
