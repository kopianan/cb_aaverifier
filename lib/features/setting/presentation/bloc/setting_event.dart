part of 'setting_bloc.dart';

@immutable
abstract class SettingEvent {}

class UploadFileToDrive extends SettingEvent {
  final UploadResponse data;
  UploadFileToDrive(this.data);
}

class EncryptDecrypt extends SettingEvent {
  final Uint8List encryptedSharedKey;
  EncryptDecrypt(this.encryptedSharedKey);
}
