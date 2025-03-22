// ignore_for_file: must_be_immutable

import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final String? title;
  bool stateValue = false;
  final void Function(bool)? onTap;
  final Color? mainFillColor;
  final Color? iconBgFillColor;
  final Color? iconColor;

  NotificationSettingsWidget({
    super.key,
    required this.title,
    required this.stateValue,
    this.iconBgFillColor,
    this.mainFillColor,
    this.iconColor,
    this.onTap,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title ?? '',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.fullBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
          FlutterSwitch(
            width: 50.0,
            height: 24.0,
            toggleSize: 25.0,
            value: widget.stateValue,
            borderRadius: 26.0,
            padding: 0,
            showOnOff: false,
            inactiveColor: AppColors.lightGrey,
            activeColor: AppColors.blueGray,
            activeToggleColor: AppColors.kPrimaryColor,
            onToggle: widget.onTap ??
                (val) {
                  log.w("Toggled");
                  setState(() {
                    widget.stateValue = val;
                  });
                },
          ),
        ],
      ),
    );
  }
}
