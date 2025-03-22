// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/models/feedback/send_feedback_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_events.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_states.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/app_constants/constants.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('ContactUsPage');

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String? formValidationError = '', emailValidator = '';

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    messageController.dispose();
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

  attemptToSendMessage() {
    if (firstNameController.text.trim().isNotEmpty == true &&
        lastNameController.text.trim().isNotEmpty == true &&
        emailController.text.trim().isNotEmpty == true &&
        messageController.text.trim().isNotEmpty == true) {
      SendFeedbackModel sendFeedbackData = SendFeedbackModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        message: messageController.text.trim(),
      );

      setState(() {
        formValidationError = '';
      });
      log.wtf("Going to send feedback message");
      BlocProvider.of<SettingsBloc>(context).add(
        SendFeedbackMessage(context, sendFeedbackData),
      );
    } else {
      setState(() {
        formValidationError = 'Kindly fill all starred(*) fields';
      });
      log.wtf("Kindly fill all starred(*) fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              backgroundColor: AppColors.plainWhite,
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.fullBlack,
                ),
              ),
              title: Text(
                "Contact US",
                style:
                    AppStyles.coloredSemiHeaderStyle(16, AppColors.fullBlack),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    "If you have any questions, comments or feedback, please don't hesitate to reach out to us.",
                    style: AppStyles.commonStringStyle(
                      16,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  customVerticalSpacer(15),
                  SelectableText(
                    orderPhoneNumber,
                    style: AppStyles.commonStringStyle(
                      16,
                      color: AppColors.fullBlack.withOpacity(0.8),
                    ),
                  ),
                  customVerticalSpacer(15),
                  SelectableText(
                    "d818.restaurant@gmail.com",
                    style: AppStyles.commonStringStyle(
                      16,
                      color: AppColors.fullBlack.withOpacity(0.8),
                    ),
                  ),
                  customVerticalSpacer(15),
                  SelectableText(
                    "www.d818.co.uk",
                    style: AppStyles.commonStringStyle(
                      16,
                      color: AppColors.amber.withOpacity(0.8),
                    ),
                  ),
                  customVerticalSpacer(25),
                  Text(
                    "Send us a message",
                    style: AppStyles.commonStringStyle(
                      14,
                      color: AppColors.fullBlack.withOpacity(0.8),
                    ),
                  ),
                  customVerticalSpacer(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        width: screenWidth(context) * 0.43,
                        mainFillColor: AppColors.lighterGrey,
                        textEditingController: firstNameController,
                        hintText: "First name*",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                      ),
                      CustomTextField(
                        width: screenWidth(context) * 0.43,
                        mainFillColor: AppColors.lighterGrey,
                        textEditingController: lastNameController,
                        hintText: "Last name*",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                  customVerticalSpacer(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        width: screenWidth(context) * 0.43,
                        mainFillColor: AppColors.lighterGrey,
                        textEditingController: emailController,
                        hintText: "Email*",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (str) => validateEmail(str.trim()),
                        borderColor: emailValidator == ''
                            ? AppColors.plainWhite
                            : AppColors.kPrimaryColor,
                      ),
                      CustomTextField(
                        width: screenWidth(context) * 0.43,
                        mainFillColor: AppColors.lighterGrey,
                        textEditingController: phoneController,
                        hintText: "Phone No.",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                  customVerticalSpacer(15),
                  CustomTextField(
                    height: 100,
                    width: screenWidth(context) - 48,
                    contentpadding: const EdgeInsets.all(10),
                    mainFillColor: AppColors.lighterGrey,
                    textEditingController: messageController,
                    hintText: "Message*",
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                  ),
                  customVerticalSpacer(10),
                  Center(
                    child: Text(
                      formValidationError ?? '',
                      style: AppStyles.lightStringStyleColored(
                        12,
                        AppColors.coolRed,
                      ),
                    ),
                  ),
                  customVerticalSpacer(3),
                  Center(
                    child: state.loading == true
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : CustomButton(
                            onPressed: () => attemptToSendMessage(),
                            width: 140,
                            height: 45,
                            borderRadius: 25,
                            color: AppColors.kPrimaryColor,
                            child: Text(
                              "Send Message",
                              style: AppStyles.coloredSemiHeaderStyle(
                                14,
                                AppColors.plainWhite,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
