import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImageAvatar extends StatelessWidget {
  final Widget? child;
  const CustomImageAvatar({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 252,
      width: 252,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kPrimaryColor,
      ),
      child: child,
    );
  }
}
