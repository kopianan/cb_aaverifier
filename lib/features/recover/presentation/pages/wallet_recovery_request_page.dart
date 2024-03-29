import 'dart:typed_data';

import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/recover_bloc.dart';

class WalletRecoveryRequestPage extends StatefulWidget {
  const WalletRecoveryRequestPage({Key? key}) : super(key: key);

  @override
  State<WalletRecoveryRequestPage> createState() =>
      _WalletRecoveryRequestPageState();
}

class _WalletRecoveryRequestPageState extends State<WalletRecoveryRequestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final address = ModalRoute.of(context)!.settings.arguments as String;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecoverBloc(),
        ),
      ],
      child: BlocConsumer<RecoverBloc, RecoverState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Wallet Recovering"),
            ),
            body: Container(
              child: Column(
                children: [
                  CBBtnPrimary(
                    text: "Approve Recovering Request",
                    onPressed: () async {
                      context
                          .read<RecoverBloc>()
                          .add(RecoverProccess(index: 2));
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
