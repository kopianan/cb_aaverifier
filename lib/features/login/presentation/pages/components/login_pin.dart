import 'package:coinbit_verifier/features/global/auth_page_header_widget.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/pages/home_page.dart';
import 'package:coinbit_verifier/features/login/presentation/bloc/login_bloc.dart';
import 'package:coinbit_verifier/features/register/presentation/widgets/pin_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPin extends StatefulWidget {
  final String? newPin;
  const LoginPin({
    Key? key,
    this.newPin,
  }) : super(key: key);
  @override
  State<LoginPin> createState() => _OnBoardingPinState();
}

class _OnBoardingPinState extends State<LoginPin> {
  final List<int> _inputtedPin = [];

  Future<bool> checkAuthenticationPin(List<int> currentPin) async {
    String _pin = '';
    for (int i = 0; i < currentPin.length; i++) {
      _pin += currentPin[i].toString();
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is LoginSuccess) {
          context.read<HomeBloc>().add(SetHash(state.hash));
          context.read<HomeBloc>().add((RetreiveEncryptedKeys(state.hash)));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CBTextAppBar(text: ""),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const AuthPageHeaderWidget(
                      title: "Konfirmasi 6 digit\nPIN Kamu",
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 41),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) => Container(
                            margin: const EdgeInsets.all(6),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffD9D9FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  height:
                                      (_inputtedPin.length > index) ? 12 : 19,
                                  width:
                                      (_inputtedPin.length > index) ? 12 : 19,
                                  decoration: BoxDecoration(
                                    color: (_inputtedPin.length > index)
                                        ? CBColors.primaryLight
                                        : CBColors.basicWhite,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                PinKeyboard(
                  withBiometric: true,
                  onTapNumber: (number) async {
                    _inputtedPin.add(number);
                    if (_inputtedPin.length > 5) {
                      bool result = await checkAuthenticationPin(_inputtedPin);
                      if (result) {
                        debugPrint('Success');
                      } else {
                        String pin = '';
                        for (var element in _inputtedPin) {
                          pin += element.toString();
                        }
                        context.read<LoginBloc>().add(LoginUsingPin(pin));
                        _inputtedPin.clear();
                      }
                    }
                    debugPrint('Pin inputted $_inputtedPin');
                    setState(() {});
                  },
                  onBiometrics: () {
                    //this action will call hardware
                    context.read<LoginBloc>().add(LoginUsingBiometry());
                  },
                  onBackspace: () {
                    if (_inputtedPin.isNotEmpty) _inputtedPin.removeLast();
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
