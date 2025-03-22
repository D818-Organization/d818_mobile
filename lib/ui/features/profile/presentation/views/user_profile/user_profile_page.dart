// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/profile_pic_helper.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/models/users/user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/presentation/custom_navbar.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_events.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_states.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/views/user_profile/edit_user_profile_page.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/views/widgets/prof_option_tiles_card.dart';
import 'package:d818_mobile_app/ui/shared/shared_res/extensions/string_ext.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:webview_flutter/webview_flutter.dart';

var log = getLogger('ProfilePage');

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    if (Globals.token != '') {
      BlocProvider.of<ProfileBloc>(context).add(GetMyProfile());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> goToPage({
    required String pageTitle,
    required String pageUrl,
  }) async {
    bool webpageLoading = true;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.plainWhite)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log.i("Loading . . .");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              webpageLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..enableZoom(true)
      ..loadRequest(Uri.parse(pageUrl));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.plainWhite,
                size: 35,
              ),
            ),
            title: Text(
              pageTitle,
              style: AppStyles.genHeaderStyle(22, 1.5),
            ),
          ),
          body: webpageLoading == true
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.coolRed),
                )
              : WebViewWidget(controller: controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);

    return ConditionalWillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.plainWhite,
            bottomNavigationBar: const CustomNavBar(currentPageIndx: 3),
            appBar: AppBar(
              backgroundColor: AppColors.plainWhite,
              surfaceTintColor: AppColors.plainWhite,
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Profile",
                style: AppStyles.coloredSemiHeaderStyle(
                  24,
                  AppColors.fullBlack,
                ),
              ),
            ),
            body: state.isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.kPrimaryColor,
                    ),
                  )
                : state.myProfileData == null && Globals.token != ''
                    ? Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Error loading your profile.  ',
                            style: AppStyles.headerStyle(
                              14,
                              color: AppColors.fullBlack.withOpacity(0.6),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Reload',
                                style: AppStyles.headerStyle(
                                  14,
                                  color: AppColors.kPrimaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => profileBloc.add(GetMyProfile()),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        child: Column(
                          children: [
                            Center(
                              child: CircleAvatar(
                                backgroundColor: AppColors.blueGray,
                                radius: 61,
                                backgroundImage: CachedNetworkImageProvider(
                                  state.myProfileData?.img ??
                                      dummyPicUrl(
                                        state.myProfileData?.gender ?? 'male',
                                      ),
                                ),
                              ),
                            ),
                            customVerticalSpacer(8),
                            Text(
                              Globals.token == ''
                                  ? ''
                                  : state.myProfileData?.fullName ?? '',
                              textAlign: TextAlign.center,
                              style: AppStyles.coloredSemiHeaderStyle(
                                  Globals.token == '' ? 1 : 24,
                                  AppColors.fullBlack),
                            ),
                            Text(
                              Globals.token == ''
                                  ? ''
                                  : state.myProfileData?.email ?? '',
                              textAlign: TextAlign.center,
                              style: AppStyles.normalStringStyle(
                                  Globals.token == '' ? 1 : 14.5),
                            ),
                            customVerticalSpacer(5),
                            Globals.token == ''
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Sign in to see your profile",
                                          textAlign: TextAlign.center,
                                          style:
                                              AppStyles.normalStringStyle(12),
                                        ),
                                        customVerticalSpacer(5),
                                        CustomButton(
                                          onPressed: () {
                                            log.w("To login screen");
                                            saveScreenToGoAfterLogin(
                                                'profilePage');
                                            context.push('/loginScreen');
                                          },
                                          width: 120,
                                          height: 40,
                                          borderRadius: 15,
                                          // color: AppColors.plainWhite,
                                          // borderColor: AppColors.coolRed,
                                          child: Text(
                                            "Sign in",
                                            style:
                                                AppStyles.commonStringStyle(15),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : ProfileOptionTilesWidget(
                                    heading: "My Profile",
                                    icon: Iconsax.user4,
                                    onPressed: () {
                                      UserModel myData = UserModel(
                                        fullName: state.myProfileData?.fullName,
                                        email: state.myProfileData?.email,
                                        address: state.myProfileData?.address,
                                        phone: state.myProfileData?.phone,
                                        gender: state.myProfileData?.gender
                                            ?.toSentenceCase(),
                                        dob: state.myProfileData?.dob,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditAccountPage(
                                            myData: myData,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            Globals.token == ''
                                ? const SizedBox.shrink()
                                : ProfileOptionTilesWidget(
                                    heading: "Transactions",
                                    icon: Iconsax.transaction_minus4,
                                    onPressed: () =>
                                        context.push('/transactionsPage'),
                                  ),
                            Globals.token == ''
                                ? const SizedBox.shrink()
                                : ProfileOptionTilesWidget(
                                    heading: "Notifications",
                                    icon: Iconsax.notification4,
                                    onPressed: () => context
                                        .push('/notificationSettingsPage'),
                                  ),
                            ProfileOptionTilesWidget(
                              heading: "Contact Us",
                              // icon: CupertinoIcons.pins,
                              icon: Icons.perm_contact_calendar_outlined,
                              onPressed: () => context.push('/contactUsPage'),
                            ),
                            ProfileOptionTilesWidget(
                              heading: "About Us",
                              icon: CupertinoIcons.question_circle,
                              onPressed: () => goToPage(
                                pageTitle: "About Us",
                                pageUrl: "https://www.d818.co.uk/about",
                              ),
                            ),
                            ProfileOptionTilesWidget(
                              heading: "Disclaimer",
                              icon: CupertinoIcons.info_circle,
                              onPressed: () => goToPage(
                                pageTitle: "Disclaimer",
                                pageUrl: "https://www.d818.co.uk/disclaimer",
                              ),
                            ),
                            ProfileOptionTilesWidget(
                              heading: "Terms and Conditions",
                              icon: CupertinoIcons.doc_circle,
                              onPressed: () => goToPage(
                                pageTitle: "Terms and Conditions",
                                pageUrl: "https://www.d818.co.uk/terms-of-use",
                              ),
                            ),
                            ProfileOptionTilesWidget(
                              heading: "Privacy Policy",
                              icon: CupertinoIcons.person_2_square_stack,
                              onPressed: () => goToPage(
                                pageTitle: "Privacy Policy",
                                pageUrl:
                                    "https://www.d818.co.uk/privacy-policy",
                              ),
                            ),
                            customVerticalSpacer(30),
                            Globals.token == ''
                                ? const SizedBox.shrink()
                                : CustomButton(
                                    onPressed: () {
                                      showLogoutConfirmation(context);
                                    },
                                    height: 50,
                                    width: screenWidth(context),
                                    color: AppColors.plainWhite,
                                    borderColor: AppColors.coolRed,
                                    borderRadius: 10,
                                    child: Text(
                                      "Log out",
                                      style: AppStyles.normalStringStyle(
                                        15,
                                        color: AppColors.coolRed,
                                      ),
                                    ),
                                  ),
                            customVerticalSpacer(14),
                            Globals.token == ''
                                ? const SizedBox.shrink()
                                : CustomButton(
                                    onPressed: () {
                                      showDeleteAccountConfirmation(context);
                                    },
                                    height: 50,
                                    width: screenWidth(context),
                                    borderRadius: 10,
                                    child: Text(
                                      "Delete My Account",
                                      style: AppStyles.normalStringStyle(
                                        15,
                                        color: AppColors.plainWhite,
                                      ),
                                    ),
                                  ),
                            customVerticalSpacer(10),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }

  showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 280,
            width: screenWidth(context) * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.plainWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Log Out",
                  style: AppStyles.coloredHeaderStyle(20, AppColors.coolRed),
                ),
                customVerticalSpacer(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Are you sure you want to log out from this account?",
                    style: AppStyles.coloredSemiHeaderStyle(
                      15,
                      AppColors.fullBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                customVerticalSpacer(15),
                Icon(
                  Icons.logout_rounded,
                  size: 70,
                  color: AppColors.fullBlack,
                ),
                customVerticalSpacer(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      height: 45,
                      borderRadius: 10,
                      width: screenWidth(context) * 0.3,
                      color: AppColors.lightGrey,
                      child: Text(
                        "Cancel",
                        style: AppStyles.coloredSemiHeaderStyle(
                          14,
                          AppColors.fullBlack,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    customHorizontalSpacer(screenWidth(context) * 0.12),
                    CustomButton(
                      height: 45,
                      borderRadius: 10,
                      width: screenWidth(context) * 0.3,
                      color: AppColors.lightGrey,
                      child: Text(
                        "Log Out",
                        style: AppStyles.coloredSemiHeaderStyle(
                          14,
                          AppColors.coolRed,
                        ),
                      ),
                      onPressed: () {
                        AuthCubit().logout();
                        context.go('/loggedOutScreen');
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 280,
            width: screenWidth(context) * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.plainWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Delete Account",
                  style: AppStyles.coloredHeaderStyle(20, AppColors.coolRed),
                ),
                customVerticalSpacer(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Are you sure you want to delete your account?",
                    style: AppStyles.coloredSemiHeaderStyle(
                      15,
                      AppColors.fullBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                customVerticalSpacer(15),
                Icon(
                  Iconsax.user_remove4,
                  size: 70,
                  color: AppColors.coolRed,
                ),
                customVerticalSpacer(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      height: 45,
                      borderRadius: 10,
                      width: screenWidth(context) * 0.3,
                      color: AppColors.lightGrey,
                      child: Text(
                        "Cancel",
                        style: AppStyles.coloredSemiHeaderStyle(
                          14,
                          AppColors.fullBlack,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    customHorizontalSpacer(screenWidth(context) * 0.12),
                    CustomButton(
                      height: 45,
                      borderRadius: 10,
                      width: screenWidth(context) * 0.3,
                      color: AppColors.coolRed,
                      child: Text(
                        "Delete",
                        style: AppStyles.coloredSemiHeaderStyle(
                          14,
                          AppColors.plainWhite,
                        ),
                      ),
                      onPressed: () {
                        AuthCubit().deleteAccount();
                        context.go('/loginScreen');
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
