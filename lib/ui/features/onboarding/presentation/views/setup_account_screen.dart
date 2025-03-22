import 'package:d818_mobile_app/app/models/onboarding/register_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/widgets/already_have_account_tile.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/curved_container.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/input_selection_widget.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/input_widget.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('SetupMyAccountScreen');

class SetupMyAccountScreen extends StatefulWidget {
  const SetupMyAccountScreen({super.key});

  @override
  State<SetupMyAccountScreen> createState() => _SetupMyAccountScreenState();
}

class _SetupMyAccountScreenState extends State<SetupMyAccountScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List<String> rolesList = [
    'Student',
    'Public',
  ];

  String? fullNameValidationError = '', formValidationError = '', selectedRole;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void validateFullName(String value) {
    log.d("Validating full name . . .");
    if (value.contains(" ")) {
      setState(() {
        fullNameValidationError = '';
      });
    } else {
      setState(() {
        fullNameValidationError = 'Enter both first and last name';
      });
    }
  }

  void attemptToSetupAccount() {
    if (fullNameValidationError == '' &&
        phoneController.text.trim().isNotEmpty == true &&
        addressController.text.trim().isNotEmpty == true &&
        selectedRole != null) {
      setState(() {
        formValidationError = '';
      });
      RegisterNewUserModel newUserModel = RegisterNewUserModel(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        role: selectedRole?.toLowerCase(),
      );
      log.w("newUserModel: ${newUserModel.toJson()}");

      BlocProvider.of<AuthCubit>(context)
          .setUpAccount(context, newUserData: newUserModel);
    } else {
      setState(() {
        formValidationError = 'Kindly fill all fields';
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
          preferredSize: Size(
            screenWidth(context),
            30,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 8,
              top: MediaQuery.of(context).viewPadding.top + 10,
              right: 8,
              bottom: 10,
            ),
            child: Text(
              "Back",
              style: AppStyles.normalStringStyle(
                10,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight(context) - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          height: 550,
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
                                    "Set Up Account",
                                    style: AppStyles.boldHeaderStyle(
                                      16.6,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                customVerticalSpacer(10),
                                Text(
                                  "Set up your account to continue",
                                  style: AppStyles.normalStringStyle(
                                    9.0,
                                    color: AppColors.fullBlack,
                                  ),
                                ),
                                customVerticalSpacer(30),
                                InputWidget(
                                  borderColor: fullNameValidationError == ''
                                      ? AppColors.transparent
                                      : AppColors.coolRed,
                                  controller: fullNameController,
                                  title: AppStrings.fullName,
                                  hintText: 'Enter your name',
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onchanged: (str) =>
                                      validateFullName(str.trim()),
                                  message: fullNameValidationError,
                                ),
                                InputWidget(
                                  controller: phoneController,
                                  title: AppStrings.phoneNumber,
                                  hintText: 'Enter your phone number',
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.phone,
                                ),
                                InputWidget(
                                  controller: addressController,
                                  title: AppStrings.address,
                                  hintText: 'Enter your address',
                                ),
                                InputSelectionWidget(
                                  title: AppStrings.role,
                                  width: screenWidth(context) - 148,
                                  valuesList: rolesList,
                                  onchanged: (val) {
                                    selectedRole = val;
                                    log.wtf("selectedRole: $selectedRole");
                                  },
                                ),
                                customVerticalSpacer(20),
                                SizedBox(
                                  height: 20,
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
                                  onPressed: () => attemptToSetupAccount(),
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
                                          state.isProcessing == true ? 10 : 0),
                                      state.isProcessing == true
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
                                customVerticalSpacer(5),
                                alreadyHaveAcountTile(context),
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
