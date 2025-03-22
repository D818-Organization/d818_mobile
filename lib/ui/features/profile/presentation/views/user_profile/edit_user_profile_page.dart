// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d818_mobile_app/app/helpers/profile_pic_helper.dart';
import 'package:d818_mobile_app/app/helpers/time_helper.dart';
import 'package:d818_mobile_app/app/models/users/update_user_model.dart';
import 'package:d818_mobile_app/app/models/users/user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/enter_email_screen.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_events.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_states.dart';
import 'package:d818_mobile_app/ui/shared/shared_res/extensions/string_ext.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/input_widget.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('EditAccountPage');

class EditAccountPage extends StatefulWidget {
  final UserModel myData;
  const EditAccountPage({super.key, required this.myData});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  String? fullNameValidationError = '',
      formValidationError = '',
      emailValidator = '',
      selectedGender;
  String? birthDateInString;
  DateTime? birthDate;

  List<String> gendersList = [
    'Male',
    'Female',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.myData.fullName);
    phoneController = TextEditingController(text: widget.myData.phone);
    addressController = TextEditingController(text: widget.myData.address);
    emailController = TextEditingController(text: widget.myData.email);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    if (widget.myData.dob != null) {
      birthDate = widget.myData.dob;
      birthDateInString = DateTimeHelper().formatDate(birthDate!);
      log.wtf(birthDateInString);
    }
    selectedGender = widget.myData.gender?.toSentenceCase();
    log.wtf("$selectedGender: ${widget.myData.gender}");
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
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

  attemptToChangeProfileImage() {
    BlocProvider.of<ProfileBloc>(context).add(
      UpdateUserProfileImage(context),
    );
  }

  attemptToDeleteProfileImage() {}

  attemptToUpdateProfile() {
    if (fullNameController.text.trim().isNotEmpty == true &&
        emailController.text.trim().isNotEmpty == true &&
        phoneController.text.trim().isNotEmpty == true &&
        addressController.text.trim().isNotEmpty == true &&
        selectedGender != null &&
        birthDateInString != null &&
        fullNameValidationError == '' &&
        emailValidator == '') {
      UpdateAccountModel updateAccountData = UpdateAccountModel(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        gender: selectedGender?.toLowerCase(),
        dob: birthDate?.toIso8601String(),
      );

      setState(() {
        formValidationError = '';
      });
      log.wtf("Going to update user profile data");
      BlocProvider.of<ProfileBloc>(context).add(
        UpdateUserProfile(context, updateAccountData),
      );
    } else {
      setState(() {
        formValidationError = 'Kindly fill all fields';
      });
      log.wtf("Kindly fill all fields");
    }
  }

  attemptToChangePassword() {}

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              backgroundColor: AppColors.plainWhite,
              surfaceTintColor: AppColors.plainWhite,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.fullBlack,
                ),
              ),
              elevation: 0,
              title: Text(
                "Edit Account Settings",
                style:
                    AppStyles.coloredSemiHeaderStyle(16, AppColors.fullBlack),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.blueGray,
                          radius: 61,
                          backgroundImage: CachedNetworkImageProvider(
                            state.myProfileData?.img ??
                                dummyPicUrl(
                                  state.myProfileData?.gender ?? 'male',
                                ),
                          ),
                        ),
                        customHorizontalSpacer(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.isLoading == true
                                ? Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  )
                                : CustomButton(
                                    onPressed: () =>
                                        attemptToChangeProfileImage(),
                                    width: 122,
                                    height: 33,
                                    borderRadius: 6,
                                    color: AppColors.lighterGrey,
                                    child: Text(
                                      "Change Picture",
                                      style: AppStyles.coloredSemiHeaderStyle(
                                        9.8,
                                        AppColors.fullBlack,
                                      ),
                                    ),
                                  ),
                            // CustomButton(
                            //   onPressed: () =>
                            //       attemptToDeleteProfileImage(),
                            //   width: 122,
                            //   height: 33,
                            //   borderRadius: 6,
                            //   color: AppColors.plainWhite,
                            //   borderColor: AppColors.lighterGrey,
                            //   child: Text(
                            //     "Delete Picture",
                            //     style:
                            //         AppStyles.coloredSemiHeaderStyle(
                            //       9.8,
                            //       AppColors.fullBlack,
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  customVerticalSpacer(10),
                  InputWidget(
                    borderColor: fullNameValidationError == ''
                        ? AppColors.transparent
                        : AppColors.coolRed,
                    controller: fullNameController,
                    title: AppStrings.fullName,
                    hintText: 'Enter your name',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onchanged: (str) => validateFullName(str.trim()),
                    message: fullNameValidationError,
                  ),
                  InputWidget(
                    borderColor: emailValidator == ''
                        ? AppColors.transparent
                        : AppColors.coolRed,
                    controller: emailController,
                    title: AppStrings.email,
                    hintText: 'Enter your email',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onchanged: (str) => validateEmail(str.trim()),
                    message: emailValidator,
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
                  // Gender and DoB
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.gender,
                                  style: AppStyles.headerStyle(14),
                                ),
                              ],
                            ),
                            customVerticalSpacer(5),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.2),
                                color: AppColors.lighterGrey,
                                border:
                                    Border.all(color: AppColors.lighterGrey),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 35,
                                    color: AppColors.transparent,
                                    width: (screenWidth(context) - 50) * 0.5,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          AppStrings.gender,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        style: AppStyles.inputStringStyle(
                                            AppColors.fullBlack
                                                .withOpacity(0.9)),
                                        items: gendersList
                                            .map(
                                              (String item) =>
                                                  DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: AppStyles
                                                          .inputStringStyle(
                                                              AppColors
                                                                  .fullBlack
                                                                  .withOpacity(
                                                                      0.9))
                                                      .copyWith(
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        value: selectedGender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                          log.wtf(
                                              "selectedGender: $selectedGender");
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          height: 35,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight:
                                              screenHeight(context) * 0.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          offset: const Offset(0, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                WidgetStateProperty.all(6),
                                            thumbVisibility:
                                                WidgetStateProperty.all(true),
                                          ),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 30,
                                            color: AppColors.fullBlack,
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: AppStyles.headerStyle(14),
                                ),
                              ],
                            ),
                            customVerticalSpacer(5),
                            InkWell(
                              onTap: () async {
                                log.wtf("Pressed Date of Birth");
                                final datePick = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (datePick != null && datePick != birthDate) {
                                  setState(() {
                                    birthDate = datePick;
                                    birthDateInString =
                                        DateTimeHelper().formatDate(birthDate!);
                                    log.wtf(birthDateInString);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.2),
                                  color: AppColors.lighterGrey,
                                  border:
                                      Border.all(color: AppColors.lighterGrey),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 35,
                                      color: AppColors.transparent,
                                      width: (screenWidth(context) - 50) * 0.5,
                                      child: Center(
                                        child: Text(
                                          birthDateInString ?? "dd/mm/yyyy",
                                          style: birthDateInString == null
                                              ? TextStyle(
                                                  fontSize: 13.5,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                )
                                              : AppStyles.inputStringStyle(
                                                  AppColors.fullBlack,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  customVerticalSpacer(2),
                  Text(
                    formValidationError ?? '',
                    style: AppStyles.lightStringStyleColored(
                      12,
                      AppColors.coolRed,
                    ),
                  ),
                  customVerticalSpacer(2),
                  state.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          onPressed: attemptToUpdateProfile,
                          width: 143,
                          color: AppColors.kPrimaryColor,
                          height: 43,
                          borderRadius: 32,
                          child: Text(
                            "Save Changes",
                            style: AppStyles.coloredSemiHeaderStyle(
                              11.5,
                              AppColors.plainWhite,
                            ),
                          ),
                        ),
                  //
                  customVerticalSpacer(30),
                  Row(
                    children: [
                      Text(
                        "Change Password",
                        style: AppStyles.coloredSemiHeaderStyle(
                            16, AppColors.fullBlack),
                      ),
                    ],
                  ),

                  customVerticalSpacer(20),
                  InputWidget(
                    controller: oldPasswordController,
                    title: "Old Password",
                    hintText: 'Enter old password',
                    textInputAction: TextInputAction.next,
                    obscure: true,
                    maxLength: 10,
                  ),
                  InputWidget(
                    controller: newPasswordController,
                    title: "New Password",
                    hintText: 'Enter new password',
                    textInputAction: TextInputAction.done,
                    obscure: true,
                    maxLength: 10,
                  ),
                  customVerticalSpacer(20),
                  state.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          width: 143,
                          color: AppColors.kPrimaryColor,
                          height: 43,
                          borderRadius: 32,
                          child: Text(
                            "Change Password",
                            style: AppStyles.coloredSemiHeaderStyle(
                              11.5,
                              AppColors.plainWhite,
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
