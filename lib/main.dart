import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/models/users/annot_user_model.dart';
import 'package:d818_mobile_app/app/resources/app.locator.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/d818_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

var log = getLogger('main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  Bloc.observer = TodoBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(AnnotatedUserModelAdapter());
  Hive.registerAdapter(AnnotatedPlanAdapter());
  await Hive.openBox<AnnotatedUserModel>(Globals.userBox);

  await dotenv.load(fileName: 'assets/.env');

  Stripe.publishableKey =
      'pk_test_51NsNuKFxAXw3aesXUWvBJ5hHOmAlwjD9aT4Fs8MIR7E8QJbpHPRmVuysSUOy5KQZ9Wb1aPg0Yaop0SQAhA42LwaX00L36qXYsK';
  // Stripe.stripeAccountId
  Stripe.merchantIdentifier = 'D818 Restaurants';

  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (value) => runApp(
      D818App(),
    ),
  );
}

class TodoBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.d('onEvent $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log.d('onChange $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.d('onTransition $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.d('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}
