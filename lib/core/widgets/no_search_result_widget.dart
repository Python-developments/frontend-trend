import 'package:flutter/material.dart';
import '../../config/locale/app_localizations.dart';

class NoSearchResultWidget extends StatelessWidget {
  const NoSearchResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "No search result".hardcoded,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 16),
          ),
        ),
        // SizedBox(height: 40,),
      ],
    );
  }
}
