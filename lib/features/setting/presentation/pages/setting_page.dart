import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/setting_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is OnDecryptSuccess) {
            context.read<SettingBloc>().add(UploadFileToDrive(state.data));
          }
          if (state is OnUploadSuccess) {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Copy and save decryption key",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          maxLines: 3,
                          minLines: 3,
                          decoration: InputDecoration(
                              labelText: "File ID",
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  await FlutterClipboard.copy(
                                      state.fileId.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("copied to clipboard"),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              )),
                          initialValue: state.fileId.toString(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: 3,
                          minLines: 3,
                          decoration: InputDecoration(
                              labelText: "Decryption Key",
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  await FlutterClipboard.copy(
                                      state.hashKey.toString());

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("copied to clipboard"),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              )),
                          initialValue: state.hashKey.toString(),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.wb_cloudy_sharp),
                title: const Text("Backup Wallet"),
                subtitle: const Text("Backup wallet to cloud storage"),
                onTap: () {
                  // final encryptedSharedKey =
                  //     context.read<HomeBloc>().globalEncryptedSharedKey;
                  // context
                  //     .read<SettingBloc>()
                  //     .add(EncryptDecrypt(encryptedSharedKey!));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
