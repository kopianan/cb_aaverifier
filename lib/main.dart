import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/services/notifications_service.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/pages/home_page.dart';
import 'package:coinbit_verifier/features/login/presentation/bloc/login_bloc.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/components/login_pin.dart';
import 'package:coinbit_verifier/features/notification/presentation/pages/notification_page.dart';
import 'package:coinbit_verifier/features/recover/presentation/bloc/recover_bloc.dart';
import 'package:coinbit_verifier/features/recover/presentation/pages/wallet_recovery_page.dart';
import 'package:coinbit_verifier/features/register/presentation/bloc/register_bloc.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_biometric.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_pin.dart';
import 'package:coinbit_verifier/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:coinbit_verifier/features/sign/presentation/bloc/sign_bloc.dart';
import 'package:coinbit_verifier/features/sign/presentation/pages/sign_page.dart';
import 'package:coinbit_verifier/features/dkg/presentation/pages/dkg_page.dart';
import 'package:coinbit_verifier/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:coinbit_verifier/features/splash/presentation/pages/splash_page.dart';
import 'package:coinbit_verifier/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rust_mpc_ffi/lib.dart';

import 'features/dkg/presentation/pages/success_dkg_page.dart';
import 'features/onboard/presentation/pages/onboard_page.dart';
import 'features/setting/presentation/pages/setting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initializeAwesomeNotification();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FCMService.subscribeFCM();

  CBRustMpc().setup();
  runApp(const MyApp());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DkgBloc(),
        ),
        BlocProvider(
          create: (context) => SplashBloc(),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => SignBloc(),
        ),
        BlocProvider(
          create: (context) => RecoverBloc(),
        ),
        BlocProvider(
          create: (context) => SettingBloc(),
        ),
      ],
      child: CBComponentInit(
        builder: () => MaterialApp(
          title: 'Flutter Demo',
          routes: {
            "/success_dkg": (_) => const SuccessDkgPage(),
            "/dkg_page": (_) => const DKGPage(),
            "/splash_page": (_) => const SplashPage(),
            "/sign_page": (_) => const SignPage(),
            "/home_page": (_) => const HomePage(),
            "/onboard_page": (_) => const OnBoardPage(),
            "/setting_page": (_) => const SettingPage(),
            "/login_page": (_) => const LoginPin(),
            "/register_page": (_) => const RegisterPin(),
            "/register_biometry": (_) => const RegisterBiometric(),
            "/wallet_recovery_page": (_) => const WalletRecoveryPage(),
            "/notification_page": (_) => const NotificationPage(),
          },
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                foregroundColor: Colors.black,
                backgroundColor: Colors.transparent,
                elevation: 0),
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/splash_page",
        ),
      ),
    );
  }
}
