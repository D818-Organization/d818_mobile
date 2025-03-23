import 'package:d818_mobile_app/app/models/onboarding/signin_model.dart';
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

var log = getLogger('LoginScreen');

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? formValidationError = '';

  @override
  void initState() {
    super.initState();
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    emailController = TextEditingController(text: authCubit.userEmail);
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  attempToLoginUser() {
    if (emailController.text.trim().isNotEmpty == true &&
        passwordController.text.trim().isNotEmpty == true) {
      formValidationError = '';
      if (passwordController.text.trim().length < 6) {
        formValidationError = "Password must be at least six(6) characters";
        setState(() {});
      } else {
        setState(() {
          formValidationError = "";
        });
        SigninModel signinData = SigninModel(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim(),
        );
        BlocProvider.of<AuthCubit>(context).loginUser(
          context,
          signinData: signinData,
        );
      }
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39),
              child: Center(
                child: CustomCurvedContainer(
                  leftPadding: 30,
                  rightPadding: 30,
                  height: 470,
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
                            "Log in",
                            style: AppStyles.boldHeaderStyle(
                              16.6,
                              color: AppColors.kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        customVerticalSpacer(10),
                        Text(
                          "Log in with your details to continue",
                          style: AppStyles.normalStringStyle(
                            12.5,
                            color: AppColors.fullBlack,
                          ),
                        ),
                        customVerticalSpacer(20),
                        InputWidget(
                          controller: emailController,
                          title: AppStrings.email,
                          hintText: 'Enter your email',
                          textInputAction: TextInputAction.next,
                        ),
                        InputWidget(
                          controller: passwordController,
                          title: AppStrings.password,
                          hintText: 'Enter your password',
                          textInputAction: TextInputAction.done,
                          obscure: true,
                        ),
                        customVerticalSpacer(15),
                        // TODO: Forgot Password Function
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => log.wtf('forgotPassword pressed'),
                              child: Text(
                                "${AppStrings.forgotPassword}?  ",
                                style: AppStyles.headerStyle(14),
                              ),
                            )
                          ],
                        ),
                        customVerticalSpacer(15),
                        formValidationError != null && formValidationError != ''
                            ? Text(
                                formValidationError ?? '',
                                textAlign: TextAlign.center,
                                style: AppStyles.lightStringStyleColored(
                                  12,
                                  AppColors.coolRed,
                                ),
                              )
                            : customVerticalSpacer(14),
                        customVerticalSpacer(8),
                        CustomButton(
                          onPressed: () => attempToLoginUser(),
                          width: screenWidth(context),
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.login,
                                style: AppStyles.coloredSemiHeaderStyle(
                                  16,
                                  AppColors.plainWhite,
                                ),
                              ),
                              customHorizontalSpacer(
                                  state.isProcessing == true ? 10 : 0),
                              state.isProcessing == true
                                  ? SizedBox(
                                      width: 25,
                                      height: 25,
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
                        alreadyHaveAcountTile(
                          context,
                          createNewAccount: true,
                        ),
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
