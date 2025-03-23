// ignore_for_file: must_be_immutable

import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class InputSelectionWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final List<String> valuesList;
  final bool? enable;
  final double? width;
  final Color? iconBgFillColor;
  final void Function(String)? onchanged;
  final Color? borderColor;
  final Color? mainFillColor;

  const InputSelectionWidget({
    super.key,
    required this.title,
    required this.valuesList,
    this.enable = true,
    this.iconBgFillColor,
    this.mainFillColor,
    this.width,
    this.message,
    this.onchanged,
    this.borderColor,
  });

  @override
  State<InputSelectionWidget> createState() => _InputSelectionWidgetState();
}

class _InputSelectionWidgetState extends State<InputSelectionWidget> {
  String? selectedValue;
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
                widget.title ?? '',
                style: AppStyles.headerStyle(14),
              ),
            ],
          ),
          customVerticalSpacer(5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.2),
              color: widget.enable == true
                  ? widget.mainFillColor ?? AppColors.plainWhite
                  : Colors.white54,
              border: widget.message != null && widget.message != ''
                  ? Border.all(color: AppColors.coolRed)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  height: 35,
                  color: AppColors.transparent,
                  width: widget.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        widget.title!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      style: AppStyles.inputStringStyle(
                          AppColors.fullBlack.withValues(alpha: 0.9)),
                      items: widget.valuesList
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: AppStyles.inputStringStyle(AppColors
                                        .fullBlack
                                        .withValues(alpha: 0.9))
                                    .copyWith(
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                        widget.onchanged!(value!);
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 35,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: screenHeight(context) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 30,
                          color: AppColors.fullBlack,
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
