import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appThemeData = ThemeData(
  primarySwatch: Colors.red,
  // useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.plainWhite,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.plainWhite,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      // TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      // TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      // TargetPlatform.android: ZoomPageTransitionsBuilder(),
      // TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
    },
  ),
);
