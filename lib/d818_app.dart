// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/resources/app.router.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_bloc.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:d818_mobile_app/ui/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class D818App extends StatelessWidget {
  D818App({super.key});

  @override
  Widget build(BuildContext context) {
    /// BlocProvider here
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<HomepageBloc>(create: (context) => HomepageBloc()),
        BlocProvider<TransactionsBloc>(create: (context) => TransactionsBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => CurrentPage(),
        child: MaterialApp.router(
          /// MaterialApp params
          title: 'D818',
          scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: appThemeData,

          /// GoRouter specific params
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        ),
      ),
    );
  }

  BuildContext? get ctx => _router.routerDelegate.navigatorKey.currentContext;
  final _router = AppRouter.router;
}
