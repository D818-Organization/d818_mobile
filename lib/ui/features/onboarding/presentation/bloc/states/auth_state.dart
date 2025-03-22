import 'package:d818_mobile_app/app/models/meals/plans_model.dart';

class AuthState {
  bool? isLoading, isProcessing, showAlreadyHaveAnAccount;
  List<PlansModel>? plans;

  AuthState({
    this.isLoading = false,
    this.isProcessing = false,
    this.plans,
    this.showAlreadyHaveAnAccount,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isProcessing,
    bool? showAlreadyHaveAnAccount,
    List<PlansModel>? plans,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        isProcessing: isProcessing ?? this.isProcessing,
        showAlreadyHaveAnAccount:
            showAlreadyHaveAnAccount ?? this.showAlreadyHaveAnAccount,
        plans: plans ?? this.plans,
      );
}

AuthState initialState = AuthState(
  isLoading: false,
  isProcessing: false,
  showAlreadyHaveAnAccount: false,
);

AuthState invalidCredentialState = AuthState();

AuthState invalidOtpState = AuthState();
