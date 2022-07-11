import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/components/login_otp.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_phone.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../global/auth_page_header_widget.dart';

class LoginAccount extends StatefulWidget {
  const LoginAccount({Key? key}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {
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
                        title: "Login Akun",
                        tag: "Masukkan nomor HP untuk masuk ke CoinBit.",
                      ),

                      SizedBox(height: 32),
                      //TODO : Textfield needed.
                      CBInputField(
                        autovalidateMode: AutovalidateMode.always,
                        hintText: '0812-XXXX-0000',
                        prefixDivider: true,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [Text('🇮🇩'), Text(' +62')],
                          ),
                        ),
                        validator: (v) {
                          if (v == "e") {
                            return "Error message";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 56),
                      InkWell(
                        child: Text(
                          "Kehilangan nomor telepon? ",
                          style: CBText.boldHeading14px
                              .copyWith(color: CBColors.primaryLight),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CBBtnPrimary(
                        text: "Login",
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginOtp()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  RichText(
                      text: TextSpan(
                          text: "Belum punya akun ? ",
                          style: CBText.mediumDetails14px
                              .copyWith(color: CBColors.iconLight),
                          children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPhone()));
                            }),
                          text: "Daftar",
                          style: CBText.mediumDetails14px
                              .copyWith(color: CBColors.primaryLight),
                        ),
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
