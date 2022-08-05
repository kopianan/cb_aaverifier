import 'package:pinenacl/ed25519.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';

/// CBInMemory
class CBCredentialInMemoryStorage {
  /// CBInMemory constructor
  CBCredentialInMemoryStorage({
    this.argonHash,
    this.keyshare,
    this.presign,
  });

  /// argonHash
  final Uint8List? argonHash;

  /// keyshare
  final Uint8List? keyshare;

  /// presign
  final Uint8List? presign;

  @override
  String toString() {
    return 'argonHash : $argonHash, keyshare : $keyshare, presign : $presign';
  }

  CBCredentialInMemoryStorage copyWith({
    Uint8List? argonHash,
    Uint8List? keyshare,
    Uint8List? presign,
  }) {
    return CBCredentialInMemoryStorage(
      argonHash: argonHash ?? this.argonHash,
      keyshare: keyshare ?? this.keyshare,
      presign: presign ?? this.presign,
    );
  }
}

/// in memory helper
class StashInMemory {
  /// factory class
  factory StashInMemory() {
    return _singleton;
  }

  /// create singleton
  StashInMemory._internal();

  /// create singleton
  static final StashInMemory _singleton = StashInMemory._internal();

  /// store stash
  late MemoryVaultStore store;

  /// credential a containing argonHash, keyshare, presign
  late Vault<CBCredentialInMemoryStorage> credential;

  /// credential key
  String get credetialKey => 'credential';

  /// Creates a store
  Future<void> init() async {
    store = await newMemoryVaultStore();

    // Creates a vault from the previously created store
    credential = await store.vault<CBCredentialInMemoryStorage>(
      name: credetialKey,
      eventListenerMode: EventListenerMode.synchronous,
    );
  }

  /// get credential
  Future<CBCredentialInMemoryStorage?> getCredential() async {
    final res = await credential.get(credetialKey);
    return res;
  }
}
