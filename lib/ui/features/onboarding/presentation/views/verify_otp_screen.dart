import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/curved_container.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

var log = getLogger('VerifyOtpScreen');

class VerifyOtpScreen extends StatefulWidget {
  final String? emailEntered;
  const VerifyOtpScreen({
    super.key,
    required this.emailEntered,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    // otpController.dispose();
    super.dispose();
  }

  Future<void> attemptToVerifyOtp(String otpEntered) async {
    await BlocProvider.of<AuthCubit>(context).verifyOtp(
      context,
      email: widget.emailEntered!,
      enteredOtp: otpEntered,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                39,
                MediaQuery.of(context).viewPadding.top,
                39,
                0,
              ),
              child: Center(
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
                            "Verify Email",
                            style: AppStyles.boldHeaderStyle(
                              16.6,
                              color: AppColors.kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        customVerticalSpacer(10),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Please enter the OTP sent to ',
                            style: AppStyles.normalStringStyle(
                              9.0,
                              color: AppColors.fullBlack,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.emailEntered,
                                style: AppStyles.headerStyle(9.0),
                              ),
                              TextSpan(
                                text: '.',
                                style: AppStyles.normalStringStyle(
                                  12.5,
                                  color: AppColors.fullBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        customVerticalSpacer(43),
                        Center(
                          child: SizedBox(
                            width: 280,
                            child: PinCodeTextField(
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                fieldHeight: 50,
                                fieldWidth: 36,
                                activeColor: AppColors.normalGreen,
                                activeFillColor: AppColors.plainWhite,
                                selectedColor: AppColors.amber,
                                selectedFillColor: AppColors.plainWhite,
                                inactiveColor: AppColors.plainWhite,
                                inactiveFillColor: AppColors.plainWhite,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              backgroundColor: AppColors.transparent,
                              enableActiveFill: true,
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              onCompleted: (value) {
                                String otpEntered = value;
                                setState(() {
                                  otpController.clear();
                                });
                                log.d("Completed: $otpEntered");
                                attemptToVerifyOtp(otpEntered);
                              },
                              onChanged: (value) {
                                log.d(value);
                                setState(() {});
                              },
                              beforeTextPaste: (text) {
                                log.d("Allowing to paste $text");
                                return false;
                              },
                              appContext: context,
                            ),
                          ),
                        ),
                        customVerticalSpacer(24),
                        state.isLoading == true
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.kPrimaryColor,
                              )
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '',
                                  children: <TextSpan>[
                                    state == invalidOtpState
                                        ? TextSpan(
                                            text: "Invalid OTP.   ",
                                            style: AppStyles.headerStyle(
                                              14,
                                              color: AppColors.coolRed,
                                            ),
                                          )
                                        : TextSpan(
                                            text: 'Didn\'t receive the OTP?   ',
                                            style: AppStyles.headerStyle(
                                              14,
                                              color: AppColors.fullBlack,
                                            ),
                                          ),
                                    TextSpan(
                                      text: 'Resend',
                                      style: AppStyles.headerStyle(
                                        14,
                                        color: AppColors.normalGreen,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async =>
                                            await BlocProvider.of<AuthCubit>(
                                                    context)
                                                .sendOtp(
                                              context,
                                              email: widget.emailEntered!,
                                            ),
                                    ),
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
      ),
    );
  }
}
