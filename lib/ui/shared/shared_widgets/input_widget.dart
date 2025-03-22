import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final double? height;
  final String? title;
  final String? message;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final bool? enable;
  final bool? obscure;
  final void Function(String)? onchanged;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final int? maxLength;

  const InputWidget({
    super.key,
    this.height,
    required this.controller,
    required this.title,
    this.enable = true,
    this.message,
    this.labelText,
    this.hintText,
    this.textInputAction,
    this.obscure,
    this.onchanged,
    this.borderColor,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title ?? '',
                style: AppStyles.headerStyle(14),
              ),
            ],
          ),
          customVerticalSpacer(5),
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.2),
              border: message != null && message != ''
                  ? Border.all(color: AppColors.coolRed)
                  : null,
            ),
            child: CustomTextField(
              height: height,
              enabled: enable ?? true,
              textEditingController: controller,
              labelText: labelText,
              hintText: hintText,
              textInputAction: textInputAction ?? TextInputAction.done,
              obscureText: obscure ?? false,
              onChanged: onchanged,
              keyboardType: keyboardType ?? TextInputType.text,
              maxLength: maxLength,
            ),
          ),
          message != null && message != ''
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        message ?? '',
                        style: AppStyles.lightStringStyleColored(
                          12,
                          AppColors.coolRed,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
