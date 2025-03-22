import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('alreadyHaveAcountTile');

Widget alreadyHaveAcountTile(BuildContext context, {bool? createNewAccount}) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        text: createNewAccount == true
            ? "Don't have an account? "
            : "Already have an account? ",
        style: AppStyles.commonStringStyle(
          14,
          color: AppColors.fullBlack,
        ),
        children: [
          TextSpan(
            text: createNewAccount == true ? "Sign up" : "Log in",
            style: AppStyles.commonStringStyle(
              14,
              color: AppColors.coolRed,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                log.wtf(createNewAccount == true
                    ? "Don't have an account? "
                    : "Already have an account");
                createNewAccount == true
                    ? context.replace('/emailSignupScreen')
                    : context.replace('/loginScreen');
              },
          ),
        ]),
  );
}
