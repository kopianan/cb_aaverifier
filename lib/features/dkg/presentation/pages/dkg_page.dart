import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DKGPage extends StatefulWidget {
  const DKGPage({Key? key}) : super(key: key);

  @override
  State<DKGPage> createState() => _DKGPageState();
}

class _DKGPageState extends State<DKGPage> {
  bool isDkg = false;
  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Wallet"),
      ),
      body: BlocListener<DkgBloc, DkgState>(
        listener: (context, state) async {
          print(state);
          if (state is GeneratingSharedKey) {
            await showDkgDialog(context);
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
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        "Create wallet by click button below and wait for the proccess",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
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
                  context.read<DkgBloc>().add(
                        ProccessDkg(
                          index: 2,
                          hash: homeBloc.globalHash!,
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDkgDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocBuilder<DkgBloc, DkgState>(
          builder: (context, state) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 200,
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(child: CircularProgressIndicator()),
                          const SizedBox(height: 20),
                          (state is GeneratingSharedKey)
                              ? const Text("Do DKG ...")
                              : state is GeneratingPresignKey
                                  ? const Text("Do Presign ...")
                                  : state is OnPresignKeyGenerated
                                      ? const Text("Generated Finished")
                                      : const Text("Waiting . . ."),
                        ],
                      ),
                    ),
                    Text(
                      "PLEASE DO NOT CLOSE APP",
                      style:
                          CBText.boldNominal20px.copyWith(color: Colors.grey),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
