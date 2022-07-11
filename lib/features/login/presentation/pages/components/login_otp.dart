import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/global/auth_page_header_widget.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/components/login_pin.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_pin.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class LoginOtp extends StatefulWidget {
  const LoginOtp({Key? key}) : super(key: key);

  @override
  State<LoginOtp> createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CBTextAppBar(text: ""),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const AuthPageHeaderWidget(
                        title: "Masukkan Kode OTP",
                        icon: Icons.email_outlined,
                        tag:
                            "Kode verifikasi telah dikirim ke 0812 xxxx xx21 melalui SMS",
                      ),

                      const SizedBox(
                        height: 32,
                      ),
                      //TODO : Textfield needed.
                      Pinput(
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        onCompleted: (value) {
                          const CBSnackbar(
                            message: "Berhasil yeay",
                            snackbarColor: CBColorType.success,
                          ).show(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPin(
                                    type: PinPageType.newPin,
                                  )));
                        },
                        defaultPinTheme: PinTheme(
                            width: 65,
                            height: 50,
                            textStyle: CBText.mediumDetails16px,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey[350]!,
                                ))),
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                      ),
                      const SizedBox(height: 17),
                      RichText(
                        text: TextSpan(
                            text: "02:00",
                            style: CBText.regulerBody14px
                                .copyWith(color: CBColors.iconLight),
                            children: [
                              TextSpan(
                                text: " . ",
                                style: CBText.mediumDetails14px
                                    .copyWith(color: CBColors.primaryLight),
                              ),
                              TextSpan(
                                text: "Belum menerima OTP? ",
                                style: CBText.mediumDetails14px
                                    .copyWith(color: CBColors.iconLight),
                              ),
                              TextSpan(
                                text: "Kirim Ulang",
                                style: CBText.mediumDetails14px
                                    .copyWith(color: CBColors.primaryLight),
                              ),
                            ]),
                      ),

                      const SizedBox(height: 56),
                      CBBtnPrimary(
                        text: "Lanjutkan",
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPin(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
