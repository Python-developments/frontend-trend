import 'package:timeago/timeago.dart' as timeago;

import '../../injection_container.dart';
import 'shared_pref.dart';

class TimeAgo {
  static SharedPref sharedPref = sl<SharedPref>();
  static String format(DateTime dateTime) {
    return timeago.format(
      dateTime,
      locale: sharedPref.languageCode,
    );
  }

  static void initLanguages() {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ar', timeago.ArMessages());
  }
}
