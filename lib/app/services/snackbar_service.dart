import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

showCustomSnackBar(
  BuildContext context, {
  required content,
  final void Function()? onpressed,
  Color? color,
  Color? actionTextColor,
  int? duration,
  IconData? icon,
  String? actionLabel,
}) {
  ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext ?? context)
      .showSnackBar(
    SnackBar(
      backgroundColor: color ?? AppColors.fullBlack,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          icon != null
              ? Icon(
                  icon,
                  color: AppColors.plainWhite,
                  size: 24,
                )
              : const SizedBox.shrink(),
          icon != null ? customHorizontalSpacer(3) : const SizedBox.shrink(),
          content is String
              ? Text(
                  content,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.coloredSemiHeaderStyle(
                    13,
                    AppColors.plainWhite,
                  ),
                )
              : content,
        ],
      ),
      duration: Duration(seconds: duration ?? 1),
      margin: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
      padding: const EdgeInsets.only(left: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      action: SnackBarAction(
        label: actionLabel ?? '',
        textColor: actionTextColor ?? AppColors.plainWhite,
        onPressed: onpressed ?? () {},
      ),
    ),
  );
}
