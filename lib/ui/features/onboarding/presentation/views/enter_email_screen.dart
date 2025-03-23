import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/widgets/already_have_account_tile.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/curved_container.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/input_widget.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('EmailSignupScreen');

TextEditingController emailController = TextEditingController();

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  String? emailValidator = '';

  @override
  void initState() {
    super.initState();
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    emailController = TextEditingController(text: authCubit.userEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> validateEmail(String emailText) async {
    log.d("Validating email . . .");

    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (emailText == '---') {
      setState(() {
        emailValidator = 'Enter a valid email';
      });
    } else {
      if (!regex.hasMatch(emailText)) {
        setState(() {
          emailValidator = 'Enter a valid email';
        });
      } else {
        setState(() {
          emailValidator = '';
        });
      }
    }
  }

  void attemptToVerifyEmail() {
    if (emailController.text.trim().isNotEmpty == true &&
        emailValidator == '') {
      saveSharedPrefsStringValue(
        stringKey: "savedEmail",
        stringValue: emailController.text.trim(),
      );
      String emailEntered = emailController.text.trim();
      log.wtf("Right");
      // Send OTP
      BlocProvider.of<AuthCubit>(context).sendOtp(
        context,
        email: emailEntered,
      );
    } else {
      log.w('Invalid Email Address');
      setState(() {
        emailValidator = 'Enter a valid email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        appBar: PreferredSize(
          preferredSize: Size(screenWidth(context), 40),
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 35,
                    color: AppColors.kPrimaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: CustomCurvedContainer(
                  leftPadding: 30,
                  rightPadding: 30,
                  height: 350,
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        Image.asset(
                          'assets/D818.png',
                          height: 70,
                          width: 90,
                        ),
                        Center(
                          child: Text(
                            "Welcome to D818",
                            style: AppStyles.boldHeaderStyle(
                              16.6,
                              color: AppColors.kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        customVerticalSpacer(10),
                        Text(
                          "Enter your email to sign up",
                          style: AppStyles.normalStringStyle(
                            12.5,
                            color: AppColors.fullBlack,
                          ),
                        ),
                        customVerticalSpacer(30),
                        InputWidget(
                          controller: emailController,
                          title: "Email",
                          hintText: "Enter your email",
                          onchanged: (p0) => validateEmail(
                            emailController.text.trim(),
                          ),
                        ),
                        customVerticalSpacer(5),
                        SizedBox(
                          height: 20,
                          child: Text(
                            emailValidator ?? '',
                            textAlign: TextAlign.center,
                            style: AppStyles.lightStringStyleColored(
                              14,
                              AppColors.coolRed,
                            ),
                          ),
                        ),
                        CustomButton(
                          onPressed: () => attemptToVerifyEmail(),
                          width: screenWidth(context),
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.contineu,
                                style: AppStyles.coloredSemiHeaderStyle(
                                  16,
                                  AppColors.plainWhite,
                                ),
                              ),
                              customHorizontalSpacer(
                                  state.isLoading == true ? 10 : 0),
                              state.isLoading == true
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.plainWhite,
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                        customVerticalSpacer(10),
                        alreadyHaveAcountTile(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
