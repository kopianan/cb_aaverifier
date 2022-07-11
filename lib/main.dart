import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/services/notifications_service.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/pages/home_page.dart';
import 'package:coinbit_verifier/features/login/presentation/bloc/login_bloc.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/components/login_pin.dart';
import 'package:coinbit_verifier/features/register/presentation/bloc/register_bloc.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_pin.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.initializeAwesomeNotification();

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
      ],
      child: CBComponentInit(
        builder: () => MaterialApp(
          title: 'Flutter Demo',
          routes: {
            "/dkg_page": (_) => const DKGPage(),
            "/splash_page": (_) => const SplashPage(),
            "/sign_page": (_) => const SignPage(),
            "/home_page": (_) => const HomePage(),
            "/login_page": (_) => const LoginPin(),
            "/register_page": (_) => const RegisterPin(
                  type: PinPageType.newPin,
                ),
          },
          theme: ThemeData(
            appBarTheme: AppBarTheme(
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
