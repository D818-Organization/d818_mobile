import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';

class CustomCurvedContainer extends StatelessWidget {
  final Color? fillColor;
  final Color? borderColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  const CustomCurvedContainer({
    super.key,
    this.fillColor,
    this.borderColor,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.2),
      ),
      child: Container(
        height: height ?? 100,
        width: width ?? screenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 5.2),
          ),
          border: Border.all(color: borderColor ?? AppColors.transparent),
          color: fillColor ?? AppColors.lightGrey,
        ),
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
          right: rightPadding,
          left: leftPadding,
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
