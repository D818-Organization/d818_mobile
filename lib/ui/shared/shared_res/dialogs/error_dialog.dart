import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';

showErrorDialog(
  BuildContext dialogContext,
  String message,
) {
  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: AppColors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(36),
                ),
                color: AppColors.plainWhite,
              ),
              width: screenSize(context).width,
              // height: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Icon(
                        Icons.error_outline_sharp,
                        color: AppColors.coolRed,
                        size: 40,
                      )),
                  customVerticalSpacer(1),
                  Text(
                    "Unsucceessful!",
                    textAlign: TextAlign.center,
                    style: AppStyles.inputStringStyle(AppColors.fullBlack),
                  ),
                  customVerticalSpacer(6),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppStyles.coloredSemiHeaderStyle(
                      13,
                      AppColors.lightGrey,
                    ),
                  ),
                  customVerticalSpacer(20),
                  CustomButton(
                    width: screenSize(context).width * 0.3,
                    height: 45,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: AppColors.plainWhite,
                    borderColor: AppColors.kPrimaryColor,
                    child: Text(
                      'Ok',
                      style: AppStyles.coloredHeaderStyle(
                        14,
                        AppColors.fullBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
