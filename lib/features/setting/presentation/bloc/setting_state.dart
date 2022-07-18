part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class OnUploadSuccess extends SettingState {
  String fileId;
  Uint8List hashKey;
  OnUploadSuccess(this.fileId, this.hashKey);
}

class OnDecryptError extends SettingState {
  final String message;
  const OnDecryptError(this.message);
}

class OnDecryptSuccess extends SettingState {
  final UploadResponse data;
  const OnDecryptSuccess(this.data);
}
