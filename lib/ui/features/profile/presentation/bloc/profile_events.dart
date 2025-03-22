import 'package:d818_mobile_app/app/models/users/update_user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileBlocEvent extends Equatable {}

class GetMyProfile extends ProfileBlocEvent {
  GetMyProfile();

  @override
  List<Object?> get props => [];
}

class UpdateUserProfile extends ProfileBlocEvent {
  final BuildContext context;
  final UpdateAccountModel? accountData;

  UpdateUserProfile(this.context, this.accountData);

  @override
  List<Object?> get props => [context, accountData];
}

class UpdateUserProfileImage extends ProfileBlocEvent {
  final BuildContext context;

  UpdateUserProfileImage(this.context);

  @override
  List<Object?> get props => [context];
}
