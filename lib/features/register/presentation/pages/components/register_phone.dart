import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/global/auth_page_header_widget.dart';
import 'package:coinbit_verifier/features/login/presentation/pages/login_page.dart';
import 'package:coinbit_verifier/features/register/presentation/pages/components/register_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPhone extends StatefulWidget {
  const RegisterPhone({Key? key}) : super(key: key);

  @override
  State<RegisterPhone> createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
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
                        title: "Buat Akun Coinbit",
                        icon: Icons.phone_outlined,
                        tag: "Daftarkan diri kamu sebelum mulai transaksi.",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CBCheckBox(
                            selected: false,
                            onChanged: (value) {},
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                  text: "Dengan mendaftar kamu setuju dengan ",
                                  style: CBText.regulerBody12px
                                      .copyWith(color: CBColors.iconLight),
                                  children: [
                                    TextSpan(
                                      text: "aturan penggunaan ",
                                      style: CBText.regulerBody12px.copyWith(
                                          color: CBColors.primaryLight),
                                    ),
                                    TextSpan(
                                      text: "dan ",
                                      style: CBText.regulerBody12px
                                          .copyWith(color: CBColors.iconLight),
                                    ),
                                    TextSpan(
                                      text: "kebijakan privasi ",
                                      style: CBText.regulerBody12px.copyWith(
                                          color: CBColors.primaryLight),
                                    ),
                                    TextSpan(
                                      text: "CoinBit.",
                                      style: CBText.regulerBody12px
                                          .copyWith(color: CBColors.iconLight),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CBBtnPrimary(
                        text: "Buat Akun",
                        onPressed: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RegisterOtp();
                          }));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  RichText(
                      text: TextSpan(
                          text: "Sudah punya akun ? ",
                          style: CBText.mediumDetails14px
                              .copyWith(color: CBColors.iconLight),
                          children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }),
                          text: "Masuk",
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
