// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('CustomNavBar');

class CustomNavBar extends StatefulWidget {
  final int currentPageIndx;
  const CustomNavBar({super.key, required this.currentPageIndx});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  void goPopUntil(BuildContext context, String routeName) {
    final router = GoRouter.of(context);
    while (router
            .routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        "/$routeName") {
      if (!context.canPop()) {
        return;
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(top: 25, right: 12, left: 12, bottom: 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrey,
              offset: const Offset(0, -2.5),
              blurRadius: 4,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
          color: AppColors.lighterGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Home Icon
          InkWell(
            onTap: () {
              log.d('Home selected');
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(0);
              context.canPop()
                  ? goPopUntil(context, "homePage")
                  : context.go("/homePage");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.currentPageIndx == 0
                    ? Image.asset('assets/home_on.png')
                    : Image.asset('assets/home_off.png'),
              ],
            ),
          ),

          /// Favourites Icon
          InkWell(
            onTap: () {
              log.d('Fav selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(1);

              log.d('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/favWeeklyMenuPage')
                  : context.replace('/favWeeklyMenuPage');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.currentPageIndx == 1
                    ? Image.asset('assets/favourite_on.png')
                    : Image.asset('assets/favourite_off.png'),
              ],
            ),
          ),

          /// Cart Icon
          InkWell(
            onTap: () {
              log.d('Cart selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(2);

              log.d('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/cartPage')
                  : context.replace('/cartPage');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.currentPageIndx == 2
                    ? Image.asset('assets/cart_on.png')
                    : Image.asset('assets/cart_off.png'),
              ],
            ),
          ),

          /// Profile Icon
          InkWell(
            onTap: () {
              log.d('Profile selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(3);

              log.d('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/profilePage')
                  : context.replace('/profilePage');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.currentPageIndx == 3
                    ? Image.asset('assets/profile_on.png')
                    : Image.asset('assets/profile_off.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
