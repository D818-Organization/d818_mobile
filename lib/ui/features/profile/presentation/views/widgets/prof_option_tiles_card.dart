import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

var log = getLogger('ProfileOptionTilesWidget');

class ProfileOptionTilesWidget extends StatelessWidget {
  final IconData icon;
  final String heading;
  final void Function()? onPressed;

  const ProfileOptionTilesWidget({
    super.key,
    required this.heading,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        tileColor: AppColors.lighterGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(
          icon,
          color: AppColors.kPrimaryColor,
          size: 24,
        ),
        title: Text(
          heading,
          style: AppStyles.normalStringStyle(15),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.kPrimaryColor,
          size: 24,
        ),
        onTap: onPressed ??
            () {
              log.w("Pressed $heading");
            },
      ),
    );
  }
}
