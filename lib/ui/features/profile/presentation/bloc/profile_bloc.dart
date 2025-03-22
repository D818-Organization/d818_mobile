// ignore_for_file: invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'dart:convert';

import 'package:d818_mobile_app/app/helpers/image_helper.dart';
import 'package:d818_mobile_app/app/models/users/update_user_model.dart';
import 'package:d818_mobile_app/app/models/users/user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_events.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('ProfileBloc');

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileState> {
  ApiServices apiServices = ApiServices();

  ProfileBloc() : super(ProfileState()) {
    on<UpdateUserProfileImage>((event, emit) async {
      await updateUserProfileImage(event.context);
    });

    on<UpdateUserProfile>((event, emit) async {
      await updateUserProfile(event.context, event.accountData!);
    });

    on<GetMyProfile>((event, emit) async {
      await getMyProfile();
    });
  }

  Future<void> updateUserProfileImage(BuildContext context) async {
    log.wtf('Choose image');
    await ImageHelper.getFromGallery(true).then(
      (selectedImage) async {
        if (selectedImage != null) {
          emit(state.copyWith(isLoading: true));
          var updateAvatarResponse = await apiServices.updateMyProfileImage(
            selectedImage,
          );
          if (updateAvatarResponse != 'error') {
            log.wtf("Successfully updated Profile Image");

            getMyProfile();
            showCustomSnackBar(
              context,
              icon: CupertinoIcons.check_mark_circled,
              content: "Profile successfully updated",
            );
          } else {
            showCustomSnackBar(
              context,
              icon: Icons.error_outline,
              content: "Error updating profile",
            );
          }
          emit(state.copyWith(isLoading: false));
        } else {
          log.w('No image selected');
        }
      },
    );
  }

  updateUserProfile(BuildContext context, UpdateAccountModel data) async {
    emit(state.copyWith(isLoading: true));
    log.d("Updating user profile  . . . ");
    var updateMyProfileResponse = await apiServices.updateMyProfile(data);

    if (updateMyProfileResponse
        .toString()
        .toLowerCase()
        .contains("updated successfully")) {
      log.wtf(
        "Successfully updated profile: ${updateMyProfileResponse.toString()}",
      );
      getMyProfile();
      showCustomSnackBar(
        context,
        icon: CupertinoIcons.check_mark_circled,
        content: "Profile successfully updated",
      );
    } else {
      log.w("Error updating profile");
      emit(state.copyWith(isLoading: false));
      showCustomSnackBar(
        context,
        icon: Icons.error_outline,
        content: "Error updating profile",
      );
    }
  }

  getMyProfile() async {
    emit(state.copyWith(isLoading: true));
    log.d("Updating user profile  . . . ");
    try {
      var getMyProfileResponse = await apiServices.getMyProfile();

      if (getMyProfileResponse.toString() != "error") {
        log.wtf(
          "Successfully fetched profile: ${getMyProfileResponse.toString()}",
        );
        UserModel myProfileData = userModelFromJson(
          jsonEncode(
            getMyProfileResponse,
          ),
        );
        log.wtf("myProfileData: ${myProfileData.toJson()}");

        emit(
          state.copyWith(
            isLoading: false,
            myProfileData: myProfileData,
          ),
        );
      } else {
        log.w("Error getting profile");
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      log.w("Error getting profile");
      emit(state.copyWith(isLoading: false));
    }
  }
}
