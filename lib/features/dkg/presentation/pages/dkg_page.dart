import 'dart:developer';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/mpc_service.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rust_mpc_ffi/lib.dart';

import '../../../../core/services/mpc_service.dart';
import '../../../../core/services/storage.dart';

class DKGPage extends StatefulWidget {
  const DKGPage({Key? key}) : super(key: key);

  @override
  State<DKGPage> createState() => _DKGPageState();
}

class _DKGPageState extends State<DKGPage> {
  bool isDkg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("DKG Proccess"),
      ),
      body: BlocListener<DkgBloc, DkgState>(
        listener: (context, state) {
          if (state is GeneratingSharedKey) {
            showDkgDialog(context);
          }
          if (state is OnPresignKeyGenerated) {
            Navigator.of(context).popUntil(ModalRoute.withName('/home_page'));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Approve DKG Proccess to create wallet.",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CBBtnPrimary(
                text: "Create Wallet",
                onPressed: () async {
                  context.read<DkgBloc>().add(ProccessDkg(index: 2));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDkgDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<DkgBloc, DkgState>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Center(child: CircularProgressIndicator()),
                  (state is GeneratingSharedKey)
                      ? Text("Do DKG ...")
                      : state is GeneratingPresignKey
                          ? Text("Do Presign ...")
                          : state is OnPresignKeyGenerated
                              ? Text("Generated Finished")
                              : Text("Waiting . . .")
                ],
              ),
            );
          },
        );
      },
    );
  }
}
