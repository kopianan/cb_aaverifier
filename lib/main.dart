import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/services/notifications_service.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/pages/home_page.dart';
import 'package:coinbit_verifier/features/sign/presentation/bloc/sign_bloc.dart';
import 'package:coinbit_verifier/features/sign/presentation/pages/sign_page.dart';
import 'package:coinbit_verifier/features/dkg/presentation/pages/dkg_page.dart';
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
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => SignBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {
          "/dkg_page": (_) => const DKGPage(),
          "/sign_page": (_) => const SignPage(),
          "/home_page": (_) => const HomePage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home_page',
      ),
    );
  }
}
