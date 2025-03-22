import 'package:d818_mobile_app/app/models/feedback/send_feedback_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsBlocEvent extends Equatable {}

class FetchSettings extends SettingsBlocEvent {
  @override
  List<Object?> get props => [];
}

class SendFeedbackMessage extends SettingsBlocEvent {
  final BuildContext context;
  final SendFeedbackModel? feedbackMessageData;

  SendFeedbackMessage(this.context, this.feedbackMessageData);

  @override
  List<Object?> get props => [context, feedbackMessageData];
}
