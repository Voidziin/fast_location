import 'package:mobx/mobx.dart';

import '../model/address_model.dart';
import '../service/address_service.dart';

class HomeController {
  HomeController({AddressService? service})
      : service = service ?? AddressService();

  final AddressService service;
  final isLoading = Observable<bool>(false);
  final results = ObservableList<AddressModel>();
  final hasSearched = Observable<bool>(false);
  final error = Observable<String?>(null);
  final lastAddress = Observable<AddressModel?>(null);

  Future<void> loadLastAddress() async {
    final address = await service.getLastAddress();
    runInAction(() => lastAddress.value = address);
  }

  Future<void> searchByCep(String cep) async {
    await _runSearch(() => service.searchByCep(cep));
  }

  Future<void> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    await _runSearch(() =>
        service.searchByAddress(uf: uf.toUpperCase(), city: city, street: street));
  }

  Future<void> _runSearch(Future<List<AddressModel>> Function() action) async {
    runInAction(() {
      isLoading.value = true;
      error.value = null;
      hasSearched.value = true;
    });
    try {
      final addresses = await action();
      runInAction(() {
        results
          ..clear()
          ..addAll(addresses);
        if (addresses.isNotEmpty) lastAddress.value = addresses.first;
      });
    } catch (exception) {
      runInAction(() {
        results.clear();
        error.value = exception.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      runInAction(() => isLoading.value = false);
    }
  }
}
