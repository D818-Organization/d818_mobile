// ignore_for_file: override_on_non_overriding_member

import 'package:d818_mobile_app/app/models/users/user_model.dart';

class ProfileState {
  ProfileState({
    this.isLoading,
    this.myProfileData,
  });

  bool? isLoading;
  UserModel? myProfileData;

  ProfileState copyWith({
    isLoading,
    uploadingPostImages,
    myProfileData,
  }) =>
      ProfileState(
        isLoading: isLoading ?? this.isLoading,
        myProfileData: myProfileData ?? this.myProfileData,
      );

  @override
  List<Object?> get props => [
        isLoading,
        myProfileData,
      ];
}
