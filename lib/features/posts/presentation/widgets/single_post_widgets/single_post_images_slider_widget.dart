import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/custom_cached_image.dart';
import 'package:widget_zoom/widget_zoom.dart';

class SinglePostImagesSliderWidget extends StatefulWidget {
  final String imageUrl;
  final double padding;
  final ValueChanged<int> onIndexChanged;

  const SinglePostImagesSliderWidget({
    Key? key,
    required this.onIndexChanged,
    required this.imageUrl,
    this.padding = 0,
  }) : super(key: key);

  @override
  State<SinglePostImagesSliderWidget> createState() =>
      _SinglePostImagesSliderWidgetState();
}

class _SinglePostImagesSliderWidgetState
    extends State<SinglePostImagesSliderWidget> {
  final List posts = ["s"];
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const SizedBox();
    }
    return Stack(
      children: [
        CarouselSlider(
          items: posts.map((media) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: _buildSingleImage(),
              ),
            );
          }).toList(),
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 2.sp,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (i, r) {
                setState(() {
                  _current = i;
                });
                widget.onIndexChanged(i);
              }),
        ),
        posts.length == 1
            ? const SizedBox()
            : Positioned(
                top: 8.sp,
                right: 16.sp,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sp),
                        color: Colors.black54),

                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text(
                        "${_current + 1}/${posts.length}",
                        style: TextStyle(color: Colors.white, fontSize: 10.sp),
                      ),
                    ),
                    // child: AnimatedSmoothIndicator(
                    //   activeIndex: _current,
                    //   count: posts.length,
                    //   effect: const SlideEffect(
                    //     activeDotColor: AppColors.black,
                    //     dotWidth: 7,
                    //     dotHeight: 7,
                    //   ),
                    // ),
                  ),
                ),
              )
      ],
    );
  }

  WidgetZoom _buildSingleImage() {
    return WidgetZoom(
      heroAnimationTag: widget.imageUrl,
      zoomWidget: CustomCachedImageWidget(
          radius: 0, size: double.infinity, imageUrl: widget.imageUrl),
    );
  }
}
