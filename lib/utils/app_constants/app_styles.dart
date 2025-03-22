// ignore_for_file: unused_field

import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  ///TextStyles
  static const FontWeight _lightWeight = FontWeight.w300;
  static const FontWeight _normalWeight = FontWeight.w400;
  static const FontWeight _regularWeight = FontWeight.w500;
  static const FontWeight _semiBoldWeight = FontWeight.w600;
  static const FontWeight _boldWeight = FontWeight.w700;
  static const FontWeight _extraBoldWeight = FontWeight.w800;

  static TextStyle genHeaderStyle(double fontSize, double lineHeight) => _base(
        fontSize,
        _boldWeight,
        AppColors.plainWhite,
      ).copyWith(height: lineHeight);

  //New cats

  static TextStyle headerStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _semiBoldWeight,
        color ?? AppColors.fullBlack,
      ).copyWith(height: 1.2);

  static TextStyle boldHeaderStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _boldWeight,
        color ?? AppColors.fullBlack,
      ).copyWith(height: 1.2);

  static TextStyle normalStringStyle(double fontSize,
          {Color? color, double? lineHeight}) =>
      _base(
        fontSize,
        _normalWeight,
        color ?? AppColors.fullBlack,
      ).copyWith(height: lineHeight ?? 1.3);

  static TextStyle commonStringStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _regularWeight,
        color ?? AppColors.plainWhite,
      ).copyWith(height: 1.2);

  static TextStyle hintStringStyle(double fontSize) => _base(
        fontSize,
        _normalWeight,
        AppColors.lightGrey,
      );

  static TextStyle lightStringStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _lightWeight,
        color ?? AppColors.plainWhite,
      ).copyWith(height: 1.2);

  //------------------

  static TextStyle coloredHeaderStyle(double fontSize, Color color) => _base(
        fontSize,
        _boldWeight,
        color,
      );

  static TextStyle semiHeaderStyle(double fontSize, double lineHeight) => _base(
        fontSize,
        _semiBoldWeight,
        AppColors.fullBlack,
      ).copyWith(height: lineHeight);

  static TextStyle coloredSemiHeaderStyle(double fontSize, Color color) =>
      _base(
        fontSize,
        _semiBoldWeight,
        color,
      );

  static TextStyle generalSubStyle(double fontSize, double lineHeight) => _base(
        fontSize,
        _semiBoldWeight,
        AppColors.plainWhite,
      ).copyWith(height: lineHeight);

  static TextStyle coloredGeneralSubStyle(double fontSize, Color color) =>
      _base(
        fontSize,
        _semiBoldWeight,
        color,
      ).copyWith(height: 1.5);

  static TextStyle mediumStringStyle(double fontSize, Color textcolor) => _base(
        fontSize,
        _regularWeight,
        textcolor,
      );

  static TextStyle navBarStringStyle(Color color) => _base(
        10,
        _regularWeight,
        color,
      );

  static TextStyle inputStringStyle(Color textcolor) => _base(
        13,
        _semiBoldWeight,
        textcolor,
      );

  static TextStyle lightStringStyleColored(double fontSize, Color color) =>
      _base(
        fontSize,
        _normalWeight,
        color,
      );

  //#base style
  static TextStyle _base(
    double size,
    FontWeight? fontWeight,
    Color? color,
  ) {
    return baseStyle(fontSize: size, fontWeight: fontWeight, color: color);
  }

  static TextStyle baseStyle({
    double fontSize = 10,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Poppins',
      fontWeight: fontWeight ?? _normalWeight,
      color: color ?? AppColors.lightGrey,
    );
  }
}
