import 'package:d818_mobile_app/app/resources/app.transitions.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/fav_meals_page.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/homepage.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/create_password_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/enter_email_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/intro_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/logged_out_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/login_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/setup_account_screen.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/student_plan_screen.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/views/user_profile/user_profile_page.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/views/contact_us_page.dart.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/views/notification_settings_page.dart';
import 'package:d818_mobile_app/ui/features/splash_screen/presentation/views/splash_screen.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/cart_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/checkout_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/complete_checkout_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/google_maps_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/transactions_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/introScreen',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/homePage',
        pageBuilder: (context, state) =>
            CustomNormalTransition(child: const HomePage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/favWeeklyMenuPage',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const FavWeeklyMenuPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/cartPage',
        pageBuilder: (context, state) =>
            CustomNormalTransition(child: const CartPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/mapScreen',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/transactionsPage',
        pageBuilder: (context, state) => CustomSlideTransition(
            child: const TransactionsPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/checkoutPage',
        pageBuilder: (context, state) => CustomSlideTransition(
            child: const CheckoutPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/checkoutCompletePage',
        pageBuilder: (context, state) => CustomSlideTransition(
            child: const CheckoutCompletePage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/notificationSettingsPage',
        pageBuilder: (context, state) => CustomSlideTransition(
            child: const NotificationSettingsPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/contactUsPage',
        pageBuilder: (context, state) => CustomSlideTransition(
            child: const ContactUsPage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/profilePage',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ProfilePage(), key: state.pageKey),
      ),
      GoRoute(
        path: '/introScreen',
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: '/emailSignupScreen',
        builder: (context, state) => const EmailSignupScreen(),
      ),
      GoRoute(
        path: '/createPasswordScreen',
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/setupAccountScreen',
        builder: (context, state) => const SetupMyAccountScreen(),
      ),
      GoRoute(
        path: '/studentPlansScreen',
        builder: (context, state) => const StudentPlansScreen(),
      ),
      GoRoute(
        path: '/loginScreen',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loggedOutScreen',
        builder: (context, state) => const LoggedOutScreen(),
      ),
    ],
  );
}
