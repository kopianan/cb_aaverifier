import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../global/errors/failure.dart';

abstract class BackupRepository {
  Future<Either<Failure, String>> signingUserGoogleDrive();
  Future<Either<Failure, String>> uploadToGoogleDrive(File file);
}
