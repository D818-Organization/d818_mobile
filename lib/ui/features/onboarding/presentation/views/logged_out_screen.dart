import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

var log = getLogger('LoggedOutScreen');

class LoggedOutScreen extends StatefulWidget {
  const LoggedOutScreen({super.key});

  @override
  State<LoggedOutScreen> createState() => _LoggedOutScreenState();
}

class _LoggedOutScreenState extends State<LoggedOutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log.i(size.height);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          15,
          MediaQuery.of(context).viewPadding.top + 50,
          15,
          0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: SizedBox.shrink()),
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Icon(
                  Iconsax.logout4,
                  size: 100,
                  color: AppColors.coolRed,
                ),
              ),
            ),
            Text(
              "You are logged out!",
              style: AppStyles.normalStringStyle(
                18,
                color: AppColors.fullBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const Expanded(flex: 2, child: SizedBox.shrink()),
            customVerticalSpacer(32),
            CustomButton(
              onPressed: () => context.replace('/loginScreen'),
              width: screenWidth(context) * 0.8,
              height: 55,
              color: AppColors.coolRed,
              borderColor: AppColors.plainWhite,
              child: Text(
                AppStrings.login,
                style: AppStyles.coloredSemiHeaderStyle(
                  16,
                  AppColors.plainWhite,
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
