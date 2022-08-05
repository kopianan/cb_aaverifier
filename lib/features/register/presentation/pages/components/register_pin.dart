import 'dart:developer';
import 'dart:io';

import 'package:coinbit_verifier/core/storage/security_service.dart';
import 'package:coinbit_verifier/features/global/auth_page_header_widget.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/register/presentation/bloc/register_bloc.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_biometric.dart';
import 'package:coinbit_verifier/features/register/presentation/widgets/pin_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PinPageType { newPin, confimPin, successPin, erroPin }
// final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

class RegisterPin extends StatefulWidget {
  const RegisterPin({
    Key? key,
  }) : super(key: key);
  @override
  State<RegisterPin> createState() => _OnBoardingPinState();
}

class _OnBoardingPinState extends State<RegisterPin> {
  final List<int> _inputtedPin = [];
  SecurityServiceImpl securityService = SecurityServiceImpl();

  PinPageType? type;
  String? previousePin;

  Future<bool> checkAuthenticationPin(List<int> currentPin) async {
    String _pin = '';
    for (int i = 0; i < currentPin.length; i++) {
      _pin += currentPin[i].toString();
    }

    return false;
  }

  @override
  void initState() {
    if (previousePin != null) {
      log(previousePin!.toString(), name: "NEW PIN");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    previousePin = args[0] as String;
    type = args[1] as PinPageType;
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is OnPinMade) {
          Navigator.of(context).pushNamed('/register_page',
              arguments: ['', PinPageType.confimPin]);
        }
        if (state is WrongPin) {
          _inputtedPin.clear();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Pin Wrong")));
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
                    AuthPageHeaderWidget(
                      title: (type == PinPageType.newPin)
                          ? "Buat 6 Digit\nPIN Kamu"
                          : "Konfirmasi 6 digit\nPIN Kamu",
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
                                        ? CBColors.primaryDark
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
                  onTapNumber: (number) async {
                    _inputtedPin.add(number);
                    if (_inputtedPin.length > 5) {
                      bool _result = await checkAuthenticationPin(_inputtedPin);
                      if (_result) {
                        debugPrint('Success');
                      } else {
                        log("Pin deleted");
                        // _inputtedPin.clear();
                      }
                      String pin = '';
                      for (var element in _inputtedPin) {
                        pin += element.toString();
                      }
                      if (type == PinPageType.newPin) {
                        context.read<RegisterBloc>().add(MakePin(pin));
                        // return RegisterPin(
                        //   type: PinPageType.confimPin,
                        //   newPin: _inputtedPin,
                        // );
                      } else {
                        securityService.generateHash(
                          pin: pin,
                          onSuccess: () {
                            _inputtedPin.clear();

                            if (Platform.isAndroid) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/register_biometry',
                                ModalRoute.withName('/splash_page'),
                                arguments: BiometricType.finger,
                              );
                            } else {
                              Navigator.of(context).pushReplacementNamed(
                                '/register_biometry',
                                arguments: BiometricType.faceid,
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Pin Successful made"),
                              ),
                            );
                          },
                        );
                        // return  RegisterBiometric(
                        //   type: BiometricType.finger,
                        // );
                      }
                    }
                    debugPrint('Pin inputted $_inputtedPin');
                    setState(() {});
                  },
                  onBiometrics: () {},
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
