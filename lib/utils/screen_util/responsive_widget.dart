import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget? largeScreen;
  final Widget wideScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget(
      {Key? key,
      required this.wideScreen,
      this.largeScreen,
      this.mediumScreen,
      this.smallScreen})
      : super(key: key);

  static double sidebarWidth = 0;

  static bool isSmallScreen(BuildContext context) {
    sidebarWidth = 0;
    return MediaQuery.of(context).size.width < 450;
  }

  static bool isMediumScreen(BuildContext context) {
    sidebarWidth = MediaQuery.of(context).size.width * 0.15;
    return MediaQuery.of(context).size.width >= 450 &&
        MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    sidebarWidth = MediaQuery.of(context).size.width * 0.25;
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1280;
  }

  static bool isWideScreen(BuildContext context) {
    sidebarWidth = MediaQuery.of(context).size.width * 0.25;
    return MediaQuery.of(context).size.width > 1280;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1280) {
          return wideScreen;
        } else if (constraints.maxWidth <= 1280 &&
            constraints.maxWidth >= 800) {
          return largeScreen ?? wideScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 450) {
          return mediumScreen ?? wideScreen;
        } else {
          return smallScreen ?? wideScreen;
        }
      },
    );
  }
}
