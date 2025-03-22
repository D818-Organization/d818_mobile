import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

Widget customLoadingindicator() {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 3,
      color: AppColors.kPrimaryColor,
    ),
  );
}
