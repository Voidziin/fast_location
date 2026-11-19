import '../../../http/dio_client.dart';
import '../model/address_model.dart';

class AddressApiRepository {
  AddressApiRepository({DioClient? client}) : _client = client ?? DioClient();
  final DioClient _client;

  Future<AddressModel?> findByCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    final response = await _client.dio.get('/$cleanCep/json/');
    final data = response.data;
    if (data is Map<String, dynamic> && data['erro'] == true) return null;
    if (data is Map<String, dynamic>) return AddressModel.fromMap(data);
    return null;
  }

  Future<List<AddressModel>> findByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final response =
        await _client.dio.get('/${uf.trim()}/${city.trim()}/${street.trim()}/json/');
    final data = response.data;
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => AddressModel.fromMap(
            item.map((key, value) => MapEntry(key.toString(), value))))
        .toList();
  }
}
