import '../../../shared/storage/local_storage.dart';
import '../model/address_model.dart';

class AddressStorageRepository {
  AddressStorageRepository({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();
  final LocalStorage _storage;
  static const _historyKey = 'history';
  static const _lastKey = 'last_address';

  Future<void> save(AddressModel address) async {
    final history = await loadHistory();
    history.removeWhere((item) => item.cep == address.cep);
    history.insert(0, address);
    await _storage.write(
        _historyKey, history.take(50).map((item) => item.toMap()).toList());
    await _storage.write(_lastKey, address.toMap());
  }

  Future<List<AddressModel>> loadHistory() async {
    final value = await _storage.read(_historyKey);
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map((item) => AddressModel.fromMap(
            item.map((key, value) => MapEntry(key.toString(), value))))
        .toList();
  }

  Future<AddressModel?> loadLast() async {
    final value = await _storage.read(_lastKey);
    if (value is! Map) return null;
    return AddressModel.fromMap(
        value.map((key, item) => MapEntry(key.toString(), item)));
  }
}
