import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/service/address_service.dart';

class HistoryController {
  HistoryController({AddressService? service})
      : service = service ?? AddressService();
  final AddressService service;
  final history = ObservableList<AddressModel>();
  final isLoading = Observable<bool>(false);

  Future<void> load() async {
    runInAction(() => isLoading.value = true);
    final addresses = await service.getHistory();
    runInAction(() {
      history
        ..clear()
        ..addAll(addresses);
      isLoading.value = false;
    });
  }
}
