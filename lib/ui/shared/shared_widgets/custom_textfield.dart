import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var log = getLogger('CustomTextField');

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.height,
    this.width,
    this.labelText,
    this.textEditingController,
    this.hasSuffixIcon = false,
    this.onSuffixIconPressed,
    this.suffix,
    this.suffixIcon,
    this.focusNode,
    this.initialValue,
    this.hasPrefixIcon = false,
    this.onPrefixIconPressed,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.readOnly,
    this.prefixStyle,
    this.floatingLabelStyle,
    this.hintStyle,
    this.suffixIconSize,
    this.obscureText,
    this.showCursor,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.onTap,
    this.mainFillColor,
    this.iconBgFillColor,
    this.cursorColor,
    this.borderColor,
    this.textAlign,
    this.textAlignVertical,
    this.inputStringStyle,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization,
    this.contentpadding,
    this.scrollPadding,
    this.onSubmitted,
    this.autofocus,
    this.enabled = true,
    this.filled,
    this.suffixText,
    this.isCollapsed,
    this.floatingLabelBehavior,
    this.hintText,
  }) : super(key: key);

  final double? height;
  final double? width;
  final EdgeInsets? scrollPadding;
  final String? labelText;
  final String? prefixText;
  final String? initialValue;
  final double? suffixIconSize;
  final String? suffixText;
  final String? hintText;
  final bool? enabled;
  final bool? filled;
  final bool? readOnly;
  final bool? autofocus;
  final bool? isCollapsed;
  final bool? showCursor;
  final int? maxLines;
  final int? maxLength;
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final bool? obscureText;
  final Widget? suffix;
  final IconData? suffixIcon;
  final FocusNode? focusNode;
  final Color? mainFillColor;
  final Color? borderColor;
  final Color? iconBgFillColor;
  final Color? cursorColor;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? inputStringStyle;
  final TextStyle? hintStyle;
  final TextStyle? prefixStyle;
  final TextStyle? floatingLabelStyle;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final void Function()? onSuffixIconPressed;
  final void Function()? onPrefixIconPressed;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentpadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height ?? 35,
        width: width ?? screenWidth(context),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.2),
          color: enabled == true
              ? mainFillColor ?? AppColors.plainWhite
              : Colors.white54,
          border: Border.all(
            color: borderColor ?? AppColors.transparent,
          ),
        ),
        child: Center(
          child: TextFormField(
            enabled: enabled,
            autofocus: autofocus ?? false,
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            obscuringCharacter: '*',
            initialValue: initialValue,
            focusNode: focusNode,
            controller: textEditingController,
            showCursor: showCursor ?? true,
            autocorrect: false,
            textAlign: textAlign ?? TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: cursorColor ?? AppColors.kPrimaryColor,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters ?? [],
            textInputAction: textInputAction,
            onChanged: onChanged,
            onTap: () =>
                onTap ?? FocusScope.of(context).requestFocus(focusNode),
            onFieldSubmitted: ((value) {
              onSubmitted ??
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
            }),
            style: inputStringStyle ??
                AppStyles.inputStringStyle(AppColors.fullBlack.withOpacity(0.9))
                    .copyWith(
                  letterSpacing: 0.8,
                ),
            decoration: InputDecoration(
              isCollapsed: isCollapsed ?? false,
              floatingLabelBehavior: floatingLabelBehavior,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.coolRed, width: 0.0),
              ),
              counterText: "",
              suffix: suffix,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              prefixText: prefixText,
              prefixStyle: prefixStyle,
              suffixText: suffixText,
              suffixStyle: AppStyles.hintStringStyle(14),
              prefixIconColor: AppColors.fullBlack,
              suffixIconColor: AppColors.fullBlack,
              labelText: labelText,
              hintText: hintText ?? '',
              labelStyle: AppStyles.hintStringStyle(12),
              hintStyle: hintStyle ??
                  AppStyles.hintStringStyle(13)
                      .copyWith(color: AppColors.fullBlack),
              filled: filled ?? false,
              fillColor: mainFillColor ?? AppColors.transparent,
              focusColor: AppColors.kPrimaryColor,
              floatingLabelStyle: floatingLabelStyle,
            ),
          ),
        ),
      ),
    );
  }
}
