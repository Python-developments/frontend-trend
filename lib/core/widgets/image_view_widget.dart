import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../resources/values_manager.dart';

class ImageViewWidget extends StatelessWidget {
  final String image;
  const ImageViewWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            PhotoView(
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: AppSize.s20,
                  height: AppSize.s20,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    value: event == null
                        ? AppSize.s0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!.toInt(),
                  ),
                ),
              ),
              imageProvider: NetworkImage(image),
            ),
            Positioned(
                top: AppSize.s10,
                right: AppSize.s10,
                child: BackButton(
                  color: Theme.of(context).primaryColor,
                )),
          ],
        ),
      ),
    );
  }
}
