import 'dart:developer';

import 'package:coinbit_secure_package/cb_encryption/cb_encryption_helper.dart';
import 'package:coinbit_verifier/core/storage/stash_in_memory.dart';

/// SecurityService abstract class
abstract class SecurityService {
  /// This action will generate new random salt Salt will be saved to
  /// local storate using [Secure Storage] Salt will used for generate
  /// new Hash and return HASHED PIN
  Future<void> generateHash({
    required String pin,
    required void Function() onSuccess,
  });

  /// encryptAndSaveHash
  Future<bool> encryptAndSaveHash();
}

/// SecurityService
class SecurityServiceImpl implements SecurityService {
  /// custom security package
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();

  /// in memory storage instance
  StashInMemory stashInMemory = StashInMemory();

  @override
  Future<void> generateHash({
    required String pin,
    required void Function() onSuccess,
  }) async {
    try {
      final argonHash = await cbEncryption.generateHash(pin);
      await stashInMemory.credential.put(
        stashInMemory.credetialKey,
        CBCredentialInMemoryStorage(argonHash: argonHash),
      );
      onSuccess();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<bool> encryptAndSaveHash() async {
    try {
      final credentialInMemory = await stashInMemory.getCredential();
      final result = await cbEncryption.encrptAndSaveHash(
        hash: credentialInMemory!.argonHash!,
      );
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// login using pin
  Future<void> getHash({
    required String pin,
  }) async {
    final argonHash = await cbEncryption.getHash(pin);
    print(argonHash);
    await stashInMemory.credential.put(
      stashInMemory.credetialKey,
      CBCredentialInMemoryStorage(argonHash: argonHash),
    );
  }

  /// login using biometric
  Future<void> getDecryptHash() async {
    final argonHash = await cbEncryption.loadAndDecryptHash();
    print(argonHash);
    await stashInMemory.credential.put(
      stashInMemory.credetialKey,
      CBCredentialInMemoryStorage(argonHash: argonHash),
    );
  }

  /// get credential and decrypt them using layer 2 decryption
  Future<void> getDecryptLayer2Credential() async {
    try {
      final res = await stashInMemory.getCredential();

      if (res != null) {
        final keyshare =
            await cbEncryption.loadEncryptedKey(res.argonHash!, 'evm-keyshare');
        print(keyshare);
        final presign =
            await cbEncryption.loadEncryptedKey(res.argonHash!, 'evm-presign');
        print(presign);
        await stashInMemory.credential.put(
          stashInMemory.credetialKey,
          CBCredentialInMemoryStorage(
            argonHash: res.argonHash,
            keyshare: keyshare,
            presign: presign,
          ),
        );
        log(
          (await stashInMemory.getCredential()).toString(),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  /// validation if creadentials and argon hash in memory
  Future<bool> checkAllInMemory() async {
    try {
      final res = await stashInMemory.getCredential();
      return res!.argonHash != null &&
              res.keyshare != null &&
              res.presign != null ||
          false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
