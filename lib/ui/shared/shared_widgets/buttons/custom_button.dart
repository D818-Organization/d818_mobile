// ignore_for_file: avoid_print

import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

var log = getLogger('CustomButton');

class CustomButton extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final void Function()? onPressed;

  const CustomButton({
    Key? key,
    required this.width,
    this.height,
    this.child,
    this.color,
    this.onPressed,
    this.borderRadius,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ??
          () {
            log.d('Custom Button pressed');
          },
      style: TextButton.styleFrom(
        fixedSize: Size(width!, height ?? 56.5),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side:
              BorderSide(width: 1, color: borderColor ?? AppColors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 5.2),
        ),
        backgroundColor: (color ?? AppColors.kPrimaryColor),
      ),
      child: child ?? const SizedBox(),
    );
  }
}
