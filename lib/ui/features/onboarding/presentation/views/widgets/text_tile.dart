import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

Widget textTile(String text, {double? width}) {
  return SizedBox(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ",
          style: AppStyles.commonStringStyle(
            9.41,
            color: AppColors.fullBlack,
          ).copyWith(height: 2.5),
        ),
        customHorizontalSpacer(5),
        SizedBox(
          width: width,
          child: Text(
            text,
            style: AppStyles.commonStringStyle(
              9.41,
              color: AppColors.fullBlack,
            ).copyWith(height: 2.0),
          ),
        ),
      ],
    ),
  );
}
