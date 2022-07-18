import 'package:coinbit_verifier/features/recover/presentation/bloc/recover_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletRecoveryPage extends StatefulWidget {
  const WalletRecoveryPage({Key? key}) : super(key: key);

  @override
  State<WalletRecoveryPage> createState() => _WalletRecoveryPageState();
}

class _WalletRecoveryPageState extends State<WalletRecoveryPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecoverBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Recover Wallet"),
      ),
      body: Column(children: [
        ListTile(
          leading: Icon(Icons.add_to_drive_sharp),
          title: Text("Get From Google Drive"),
          onTap: () {
            String hardCodeFileId = '1eK4rW27vhccMW36nNZlT-cyKEgLofxmx';
            bloc.add(GetEncryptedKeyFromStorage(hardCodeFileId));
          },
        )
      ]),
    );
  }
}
