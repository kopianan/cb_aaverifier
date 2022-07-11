import 'dart:developer';
import 'dart:typed_data';

import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/global/auth_page_header_widget.dart';
import 'package:coinbit_verifier/features/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BiometricType { finger, faceid }

class RegisterBiometric extends StatefulWidget {
  const RegisterBiometric({Key? key, required this.type, this.hash})
      : super(key: key);
  final Uint8List? hash;
  final BiometricType type;

  @override
  State<RegisterBiometric> createState() => _RegisterBiometricState();
}

class _RegisterBiometricState extends State<RegisterBiometric> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        print(state);
        if (state is OnHashSavedWithBiometry) {
          log("Hash Saved", name: "HASH");
          Navigator.of(context).pushNamed('/home_page');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CBTextAppBar(text: ""),
          body: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                (widget.type == BiometricType.faceid)
                    ? const AuthPageHeaderWidget(
                        image: CustomIcon.icFaceId,
                        title: "Atur Face ID",
                        tag:
                            "Aktifkan fitur identifikasi wajah untuk login lebih cepat dan mudah.",
                      )
                    : const AuthPageHeaderWidget(
                        image: CustomIcon.icFingerprint,
                        title: "Atur Sidik Jari",
                        tag:
                            "Aktifkan fitur sidik jari untuk login lebih cepat dan mudah.",
                      ),
                const SizedBox(),
                Column(
                  children: [
                    CBBtnPrimary(
                      text: "Aktifkan Sekarang",
                      onPressed: () async {
                        context
                            .read<RegisterBloc>()
                            .add(ActivateBiometry(widget.hash!));
                      },
                    ),
                    const SizedBox(height: 32),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home_page',
                            ModalRoute.withName('/register_page'));
                      },
                      child: Text(
                        "Lewati",
                        style: CBText.mediumDetails16px
                            .copyWith(color: CBColors.primaryLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
