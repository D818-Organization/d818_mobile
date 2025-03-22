// ignore_for_file: invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'package:d818_mobile_app/app/models/feedback/send_feedback_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_events.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('Home_bloc');

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsState> {
  ApiServices apiServices = ApiServices();

  SettingsBloc() : super(SettingsState()) {
    on<FetchSettings>((event, emit) async {
      // await getFeeds(event.context);
    });

    on<SendFeedbackMessage>((event, emit) async {
      await sendFeedbackMessage(event.context, event.feedbackMessageData!);
    });
  }
  sendFeedbackMessage(
    BuildContext context,
    SendFeedbackModel feedbackMessageData,
  ) async {
    emit(state.copyWith(loading: true));
    log.d("Sending feedback . . . ");
    var sendFeedbackMessageResponse =
        await apiServices.sendFeedbackMessage(feedbackMessageData);

    if (sendFeedbackMessageResponse
        .toString()
        .toLowerCase()
        .contains("error")) {
      log.w("Error sending feedback");
      emit(state.copyWith(loading: false));
      showCustomSnackBar(
        context,
        icon: Icons.error_outline,
        content: "Error sending feedback",
      );
    } else {
      emit(state.copyWith(loading: false));
      log.wtf("Successfully sent feedback");
      showCustomSnackBar(
        context,
        icon: CupertinoIcons.check_mark_circled,
        content: "Successfully sent feedback",
      );
    }
  }
}
