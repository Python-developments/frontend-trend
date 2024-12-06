import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/bloc_observer.dart';
import 'app/app.dart';
import 'core/utils/timeago_utils.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
  await di.init();
  TimeAgo.initLanguages();
  Bloc.observer = AppBlocObserver();
  runApp(const TrendApp());
}
