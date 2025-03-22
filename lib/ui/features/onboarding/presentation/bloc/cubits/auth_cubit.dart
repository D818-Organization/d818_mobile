// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/hive_helper.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/models/meals/plans_model.dart';
import 'package:d818_mobile_app/app/models/onboarding/otp_resp_model.dart';
import 'package:d818_mobile_app/app/models/onboarding/register_model.dart';
import 'package:d818_mobile_app/app/models/onboarding/signin_model.dart';
import 'package:d818_mobile_app/app/models/users/user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/verify_otp_screen.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('AuthCubit');

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(initialState);
  ApiServices apiServices = ApiServices();
  RegisterNewUserModel newUser = RegisterNewUserModel();
  String? userEmail, userPassword, userPlanId, otpReturned;

  sendOtp(
    BuildContext context, {
    required String email,
  }) async {
    emit(state.copyWith(isProcessing: true, isLoading: true));

    var requestOtpResponse = await apiServices.requestOtp(email.toLowerCase());
    try {
      if (requestOtpResponse['success'].toString() == 'true') {
        OtpResponseModel otpData = otpResponseModelFromJson(
          jsonEncode(
            requestOtpResponse,
          ),
        );
        log.wtf("otpData: ${otpData.toJson()}");
        otpReturned = otpData.otp;

        showCustomSnackBar(
          context,
          icon: Icons.check_circle_outline_sharp,
          content: "OTP sent",
          color: AppColors.fullBlack,
          duration: 3,
        );
        emit(state.copyWith(isProcessing: false, isLoading: false));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              emailEntered: email,
            ),
          ),
        );
      } else {
        if (requestOtpResponse['message'].toString().toLowerCase() ==
            'Customer is already registered'.toLowerCase()) {
          handleError(context,
              errorMesage: "Email is already in use. Login instead'");
        } else {
          handleError(context, errorMesage: "Error sending OTP");
        }
      }
    } catch (e) {
      emit(state.copyWith(isProcessing: false, isLoading: false));
      if (requestOtpResponse.toString().contains("exist")) {
        showCustomSnackBar(
          context,
          icon: Icons.error_outline,
          content: "Account already exists",
          color: AppColors.fullBlack,
          duration: 3,
        );
      } else {
        showCustomSnackBar(
          context,
          icon: Icons.error_outline,
          content: "Error occured",
          color: AppColors.fullBlack,
          duration: 3,
        );
      }
    }
  }

  verifyOtp(
    BuildContext context, {
    required String email,
    required String enteredOtp,
  }) async {
    emit(state.copyWith(isProcessing: true, isLoading: true));

    userEmail = email.toLowerCase();

    if (enteredOtp == otpReturned) {
      context.push('/createPasswordScreen');
    } else {
      emit(invalidOtpState);
      log.w("Invalid OTP");
    }
    emit(state.copyWith(isProcessing: false, isLoading: false));
  }

  createPassword(BuildContext context, {required String password}) async {
    emit(state.copyWith(isLoading: true));
    userPassword = password;
    log.d(
        "User data: $userEmail, $userPassword, $userPlanId ${newUser.toJson()} ");
    await Future.delayed(const Duration(seconds: 0)).then(
      (value) {
        log.w("Password created");
        emit(state.copyWith(isLoading: false));
        context.go('/setupAccountScreen');
      },
    );
  }

  setUpAccount(
    BuildContext context, {
    required RegisterNewUserModel newUserData,
  }) async {
    newUser = newUser.copyWith(
      address: newUserData.address,
      phone: newUserData.phone,
      fullName: newUserData.fullName,
      role: newUserData.role,
    );
    log.wtf(
        "User data: $userEmail, $userPassword, $userPlanId ${newUser.toJson()} ");

    // if (newUser.role == 'student') {
    //   log.w("Go to studentPlansScreen");
    //   await getAllPlans();
    //   context.push('/studentPlansScreen');
    // } else {
    log.w("Registering user.");
    registerCustomer(context);
    // }
  }

  createStudentAccount(
    BuildContext context, {
    required String planId,
  }) async {
    emit(state.copyWith(isProcessing: true, isLoading: true));
    userPlanId = planId;
    registerCustomer(context);
  }

  registerCustomer(BuildContext context) async {
    emit(state.copyWith(isProcessing: true, isLoading: true));
    String newUserDataJson;

    // if (newUser.role?.toLowerCase() == 'student') {
    //   RegisterNewUserModel newUserData = RegisterNewUserModel(
    //     email: userEmail,
    //     password: userPassword,
    //     plan: userPlanId,
    //     fullName: newUser.fullName,
    //     address: newUser.address,
    //     phone: newUser.phone,
    //     role: newUser.role?.toLowerCase(),
    //   );
    //   newUserDataJson = registerNewUserModelToJson(newUserData);
    // } else {
    RegisterNewUserNoPlanModel newUserNoPlanData = RegisterNewUserNoPlanModel(
      email: userEmail,
      password: userPassword,
      fullName: newUser.fullName,
      address: newUser.address,
      phone: newUser.phone,
      role: newUser.role?.toLowerCase(),
    );
    newUserDataJson = registerNewUserNoPlanModelToJson(newUserNoPlanData);
    // }
    log.wtf("New user data: $newUserDataJson");

    // Register new customer
    var registerResponse = await apiServices.register(newUserDataJson);

    if (registerResponse
        .toString()
        .contains("Email or phone number already exists")) {
      log.w("Email or phone number already exists");
      emit(state.copyWith(
        showAlreadyHaveAnAccount: true,
        isLoading: false,
        isProcessing: false,
      ));
      showCustomSnackBar(
        context,
        icon: Icons.error_outline,
        content: "Email or phone number already exists",
        color: AppColors.fullBlack,
        duration: 3,
      );
    } else if (registerResponse.toString() == 'error') {
      handleError(context, errorMesage: "Error creating account");
    } else {
      try {
        final dataBody = registerResponse['response'];
        SignInResponseModel responseRegisterData = signInResponseModelFromJson(
          jsonEncode(
            dataBody,
          ),
        );
        log.wtf("Created account: ${responseRegisterData.toJson()}");

        SigninModel signinData = SigninModel(
          email: userEmail,
          password: userPassword,
        );

        // Sign in
        loginUser(context, signinData: signinData);
      } catch (e) {
        handleError(context, errorMesage: "Error Creating account");
      }
    }
  }

  loginUser(BuildContext context, {required SigninModel signinData}) async {
    emit(state.copyWith(isProcessing: true, isLoading: true));
    var signinResponse = await apiServices.signin(signinData);

    if (signinResponse.toString() == 'Invalid email or password') {
      log.w("signinResponse.toString()");
      handleError(context, errorMesage: "Invalid email or password");
    } else if ((signinResponse.toString() == 'error')) {
      log.w("signinResponse.toString()");
      handleError(context, errorMesage: "Error signing in");
    } else {
      try {
        SignInResponseModel responseLoginData = signInResponseModelFromJson(
          jsonEncode(
            signinResponse,
          ),
        );
        try {
          // Set Global vars and save data locally
          await saveDataLocally(responseLoginData);
          emit(initialState);
          log.w("Here ^^^^^^^^^^^^^^^^^ Emitted");
        } catch (e) {
          log.w(e.toString());
        }

        log.wtf('Going to Home screen');
        emit(state.copyWith(isProcessing: false, isLoading: false));

        final savedScreenRoute = await getScreenToGoAfterLogin();
        if (savedScreenRoute == '') {
          NavigationService.navigatorKey.currentContext?.go('/homePage');
        } else {
          NavigationService.navigatorKey.currentContext?.push('/homePage');

          NavigationService.navigatorKey.currentContext
              ?.push('/$savedScreenRoute');
          saveScreenToGoAfterLogin('');
        }
      } catch (e) {
        handleError(context, errorMesage: "Error signing in");
      }
    }
  }

  getAllPlans() async {
    emit(state.copyWith(
      isLoading: true,
      isProcessing: true,
    ));
    // Get all plans
    var getPlansResponse = await apiServices.getPlans();

    List<PlansModel> plansList = [];

    if (getPlansResponse.toString() == "error") {
      log.w("Error getting plans");
      emit(state.copyWith(
        isLoading: false,
        isProcessing: false,
      ));
    } else {
      log.wtf(
        "Successfully fetched Plans: ${getPlansResponse.toString()}",
      );
      var dataBody = getPlansResponse;
      if (dataBody != null) {
        plansList = (dataBody)
            .map((i) => PlansModel.fromJson(i))
            .toList()
            .cast<PlansModel>();
      }
      log.wtf("Last user: ${plansList.last.toJson()}");
    }

    emit(state.copyWith(
      isLoading: false,
      isProcessing: false,
      plans: plansList,
    ));
    log.w("Done : ${state.plans?.length}");
  }

  logout() async {
    await saveSharedPrefsStringValue(
      stringKey: "savedToken",
      stringValue: "",
    );
  }

  deleteAccount() async {
    await saveSharedPrefsStringValue(
      stringKey: "savedToken",
      stringValue: "",
    );
  }

  Future<void> saveDataLocally(SignInResponseModel userData) async {
    Globals.token = userData.token!;
    Globals.fullname = userData.fullName!;
    Globals.email = userData.email!;
    await saveSharedPrefsStringValue(
      stringKey: "savedFullName",
      stringValue: userData.fullName!,
    );
    await saveSharedPrefsStringValue(
      stringKey: "savedEmail",
      stringValue: userData.email!,
    );
    await saveSharedPrefsStringValue(
      stringKey: "savedUserId",
      stringValue: userData.id.toString(),
    );
    await saveSharedPrefsStringValue(
      stringKey: "savedToken",
      stringValue: userData.token.toString(),
    );
    UserModel data = UserModel(
      id: userData.id,
      email: userData.email,
      phone: userData.phone,
      fullName: userData.fullName,
      address: userData.address,
      role: userData.role,
      token: userData.token,
      plan: Plan(id: userData.plan),
    );

    HiveHelper.saveUserDataLocally(data);
  }

  handleError(BuildContext context, {required String errorMesage}) {
    emit(state.copyWith(
      isLoading: false,
      isProcessing: false,
    ));
    showCustomSnackBar(
      context,
      icon: Icons.error_outline,
      content: errorMesage,
      color: AppColors.fullBlack,
      duration: 3,
    );
  }
}
