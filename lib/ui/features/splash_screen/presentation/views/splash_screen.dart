// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('SplashScreen');

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..forward();

    sizeAnimation = Tween(begin: 20.0, end: 50.0).animate(CurvedAnimation(
        parent: animationController!, curve: const Interval(0.0, 0.5)));

    animationController!.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          log.wtf('Animation completed');
          Future.delayed(const Duration(milliseconds: 200));
          checkExistingSession();
        }
      },
    );
  }

  void checkExistingSession() async {
    String savedToken = await getSharedPrefsSavedString("savedToken");
    if (savedToken != '') {
      Globals.token = savedToken;
      log.d("Globals.token = $savedToken");

      String savedFullName = await getSharedPrefsSavedString("savedFullName");
      Globals.fullname = savedFullName;
      String savedEmail = await getSharedPrefsSavedString("savedEmail");
      Globals.email = savedEmail;

      Provider.of<CurrentPage>(
              NavigationService.navigatorKey.currentContext ?? context,
              listen: false)
          .setCurrentPageIndex(0);
      NavigationService.navigatorKey.currentContext?.replace('/homePage');
    } else if (await getSharedPrefsSavedString("notFirstTime") == 'true') {
      Provider.of<CurrentPage>(
              NavigationService.navigatorKey.currentContext ?? context,
              listen: false)
          .setCurrentPageIndex(0);
      NavigationService.navigatorKey.currentContext?.replace('/homePage');
    } else {
      NavigationService.navigatorKey.currentContext?.replace('/introScreen');
    }
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: Scaffold(
        // backgroundColor: AppColors.kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: AnimatedBuilder(
              animation: animationController!,
              builder: (context, child) {
                return Image.asset(
                  'assets/D818.png',
                  height: sizeAnimation!.value * 3.5,
                  width: sizeAnimation!.value * 3.5,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
