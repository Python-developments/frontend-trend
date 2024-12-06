import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class PostsShimmer extends StatelessWidget {
  const PostsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Padding(
        padding: EdgeInsets.only(top: 4.sp),
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42.sp,
                              height: 42.sp,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                            ),
                            SizedBox(width: 6.sp),
                            Container(
                              width: 35.sp,
                              height: 6.sp,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 5.sp,
                              height: 5.sp,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                            ),
                            SizedBox(
                              width: 3.sp,
                            ),
                            Container(
                              width: 5.sp,
                              height: 5.sp,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Container(
                              width: 5.sp,
                              height: 5.sp,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).width,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 12.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 35.sp,
                          height: 4.sp,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                        ),
                        SizedBox(height: 5.sp),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 4.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 5.sp),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 3.sp,
                          height: 4.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.sp),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
