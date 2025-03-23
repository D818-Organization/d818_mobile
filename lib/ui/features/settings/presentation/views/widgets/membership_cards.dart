import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';

var log = getLogger('MembershipOptionsCard');

class MembershipOptionsCard extends StatelessWidget {
  final String tariffCost;
  final List<bool> isFeatureAvailable;
  final void Function()? onTap;
  const MembershipOptionsCard({
    super.key,
    required this.tariffCost,
    required this.isFeatureAvailable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      width: screenWidth(context),
      height: 474,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 471,
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(48),
        ),
        child: Column(
          children: [
            tariffCost.toUpperCase() == "FREE"
                ? const SizedBox.shrink()
                : Image.asset('assets/crown.png'),
            customVerticalSpacer(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$${tariffCost.toUpperCase()}",
                  style: AppStyles.genHeaderStyle(32, 1),
                ),
                Text(
                  " /month",
                  style: AppStyles.mediumStringStyle(18, AppColors.plainWhite),
                ),
              ],
            ),
            customVerticalSpacer(16),
            Container(
              color: AppColors.blueGray,
              height: 1,
              width: screenHeight(context) * 0.7,
            ),
            customVerticalSpacer(16),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[0],
              featureText: "Join",
            ),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[1],
              featureText: "Search For Match",
            ),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[2],
              featureText: "Month Recurring",
            ),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[3],
              featureText: "Unlimited Text Messages",
            ),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[4],
              featureText: "Video Chatting",
            ),
            featureTile(
              context,
              isAvailable: isFeatureAvailable[5],
              featureText: "Boost For a Week",
            ),
            const Expanded(child: SizedBox()),
            CustomButton(
              width: screenWidth(context),
              height: 55,
              color: tariffCost.toUpperCase() == "FREE"
                  ? AppColors.blueGray.withValues(alpha: 0.6)
                  : AppColors.regularBlue,
              onPressed: tariffCost.toUpperCase() == "FREE"
                  ? () {
                      log.w("Pressed Free");
                    }
                  : onTap,
              child: Text(
                "Purchase",
                style: AppStyles.coloredSemiHeaderStyle(
                  16,
                  AppColors.plainWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget featureTile(BuildContext context,
    {required bool isAvailable, required String featureText}) {
  return Container(
    height: 38,
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Image.asset(
          isAvailable ? "assets/mark.png" : "assets/cross.png",
        ),
        customHorizontalSpacer(20),
        Text(
          featureText,
          style: AppStyles.mediumStringStyle(
            16,
            AppColors.plainWhite,
          ),
        ),
      ],
    ),
  );
}
