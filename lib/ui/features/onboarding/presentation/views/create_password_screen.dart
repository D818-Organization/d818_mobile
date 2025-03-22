import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
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

var log = getLogger('CreatePasswordScreen');

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? formValidationError = '';

  validateField() {
    if (passwordController.text.trim().isEmpty == true &&
        confirmPasswordController.text.trim().isEmpty == true) {
      formValidationError = '';
    } else if (passwordController.text.trim().length >= 6 &&
        confirmPasswordController.text.trim().length >= 6) {
      formValidationError = '';
    } else {
      formValidationError =
          'Password length must be between six (6) and ten (10) ';
    }
    setState(() {});
  }

  attemptToCreatePassword() async {
    if (passwordController.text.trim().isEmpty == true ||
        confirmPasswordController.text.trim().isEmpty == true) {
      setState(() {
        formValidationError = "\nKindly fill both fields";
      });
    } else {
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        setState(() {
          formValidationError = "";
        });
        String createdPassword = passwordController.text.trim();
        log.wtf("Password set");
        BlocProvider.of<AuthCubit>(context)
            .createPassword(context, password: createdPassword);
      } else {
        setState(() {
          formValidationError = "\nPasswords do not match";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            height: screenHeight(context),
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                BlocBuilder<AuthCubit, AuthState>(
                  bloc: authCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 39),
                      child: Center(
                        child: CustomCurvedContainer(
                          fillColor: AppColors.lighterGrey,
                          leftPadding: 30,
                          rightPadding: 30,
                          height: 430,
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
                                    "Create Password",
                                    style: AppStyles.boldHeaderStyle(
                                      16.6,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                customVerticalSpacer(10),
                                Text(
                                  "Let's get started by creating your account password. To keep your account safe, use a strong password",
                                  style: AppStyles.normalStringStyle(
                                    9.0,
                                    color: AppColors.fullBlack,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                customVerticalSpacer(30),
                                InputWidget(
                                  controller: passwordController,
                                  title: AppStrings.password,
                                  hintText: 'Enter your preferred password',
                                  textInputAction: TextInputAction.next,
                                  obscure: true,
                                  onchanged: (p0) => validateField(),
                                ),
                                InputWidget(
                                  controller: confirmPasswordController,
                                  title: AppStrings.confirmPassword,
                                  hintText: 'Confirm your preferred password',
                                  textInputAction: TextInputAction.done,
                                  obscure: true,
                                  onchanged: (p0) => validateField(),
                                ),
                                customVerticalSpacer(15),
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                    formValidationError ?? '',
                                    textAlign: TextAlign.center,
                                    style: AppStyles.lightStringStyleColored(
                                      14,
                                      AppColors.coolRed,
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  onPressed: () => attemptToCreatePassword(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
