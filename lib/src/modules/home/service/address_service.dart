import '../model/address_model.dart';
import '../repositories/address_api_repository.dart';
import '../repositories/address_storage_repository.dart';

class AddressService {
  AddressService({
    AddressApiRepository? api,
    AddressStorageRepository? storage,
  })  : _api = api ?? AddressApiRepository(),
        _storage = storage ?? AddressStorageRepository();

  final AddressApiRepository _api;
  final AddressStorageRepository _storage;

  Future<List<AddressModel>> searchByCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    if (cleanCep.length != 8) throw Exception('Informe um CEP válido com 8 dígitos.');
    final address = await _api.findByCep(cleanCep);
    if (address == null) return [];
    await _storage.save(address);
    return [address];
  }

  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    if (uf.length != 2 || city.trim().length < 3 || street.trim().length < 3) {
      throw Exception('Informe UF, cidade e ao menos 3 letras da rua.');
    }
    final addresses =
        await _api.findByAddress(uf: uf, city: city, street: street);
    if (addresses.isNotEmpty) await _storage.save(addresses.first);
    return addresses;
  }

  Future<AddressModel?> getLastAddress() => _storage.loadLast();
  Future<List<AddressModel>> getHistory() => _storage.loadHistory();
}
