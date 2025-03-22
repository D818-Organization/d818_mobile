// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_states.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/views/widgets/notif_settings_card.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('NotificationSettingsPage');

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool genNotifStatus = true,
      soundNotifStatus = true,
      vibrationNotifStatus = false,
      appUpdatesNotifStatus = true,
      billReminderNotifStatus = true,
      promotionNotifStatus = true,
      discountNotifStatus = true,
      paymentRequestNotifStatus = true,
      newServicesNotifStatus = true,
      newTipsNotifStatus = true;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
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
                "Notifications",
                style:
                    AppStyles.coloredSemiHeaderStyle(16, AppColors.fullBlack),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "General",
                    style: AppStyles.headerStyle(16),
                  ),
                  customVerticalSpacer(15),
                  NotificationSettingsWidget(
                    title: "General Notification",
                    stateValue: genNotifStatus,
                    onTap: (val) => setState(() {
                      genNotifStatus = !genNotifStatus;
                      log.w("genNotifStatus - $genNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Sound",
                    stateValue: soundNotifStatus,
                    onTap: (val) => setState(() {
                      soundNotifStatus = !soundNotifStatus;
                      log.w("soundNotifStatus - $soundNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Vibrate",
                    stateValue: vibrationNotifStatus,
                    onTap: (val) => setState(() {
                      vibrationNotifStatus = !vibrationNotifStatus;
                      log.w("vibrationNotifStatus - $vibrationNotifStatus");
                    }),
                  ),
                  customVerticalSpacer(20),

                  // System & services update
                  Text(
                    "System & services update",
                    style: AppStyles.headerStyle(16),
                  ),
                  NotificationSettingsWidget(
                    title: "App Updates",
                    stateValue: appUpdatesNotifStatus,
                    onTap: (val) => setState(() {
                      appUpdatesNotifStatus = !appUpdatesNotifStatus;
                      log.w("appUpdatesNotifStatus - $appUpdatesNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Bill Reminder",
                    stateValue: billReminderNotifStatus,
                    onTap: (val) => setState(() {
                      billReminderNotifStatus = !billReminderNotifStatus;
                      log.w(
                          "billReminderNotifStatus - $billReminderNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Promotion",
                    stateValue: promotionNotifStatus,
                    onTap: (val) => setState(() {
                      promotionNotifStatus = !promotionNotifStatus;
                      log.w("promotionNotifStatus - $promotionNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Discount Available",
                    stateValue: discountNotifStatus,
                    onTap: (val) => setState(() {
                      discountNotifStatus = !discountNotifStatus;
                      log.w("discountNotifStatus - $discountNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "Payment Request",
                    stateValue: paymentRequestNotifStatus,
                    onTap: (val) => setState(() {
                      paymentRequestNotifStatus = !paymentRequestNotifStatus;
                      log.w(
                          "paymentRequestNotifStatus - $paymentRequestNotifStatus");
                    }),
                  ),
                  customVerticalSpacer(20),

                  // Others
                  Text(
                    "Others",
                    style: AppStyles.headerStyle(16),
                  ),
                  NotificationSettingsWidget(
                    title: "New Service Available",
                    stateValue: newServicesNotifStatus,
                    onTap: (val) => setState(() {
                      newServicesNotifStatus = !newServicesNotifStatus;
                      log.w("newServicesNotifStatus - $newServicesNotifStatus");
                    }),
                  ),
                  NotificationSettingsWidget(
                    title: "New Tips Available",
                    stateValue: newTipsNotifStatus,
                    onTap: (val) => setState(() {
                      newTipsNotifStatus = !newTipsNotifStatus;
                      log.w("newTipsNotifStatus - $newTipsNotifStatus");
                    }),
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
