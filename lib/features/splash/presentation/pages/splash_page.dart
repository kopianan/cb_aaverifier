import 'package:coinbit_verifier/features/home/presentation/pages/home_page.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/components/login_pin.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/login_page.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_pin.dart';
import 'package:coinbit_verifier/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<SplashBloc>().add(CheckUserLogin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is OnUserExist) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPin(),
            ),
          );
        }

        if (state is OnUserNotExist) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const RegisterPin(
                type: PinPageType.newPin,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
