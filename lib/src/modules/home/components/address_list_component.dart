import 'package:material_ui/material_ui.dart';

import '../model/address_model.dart';

class AddressListComponent extends StatelessWidget {
  const AddressListComponent({super.key, required this.addresses});
  final List<AddressModel> addresses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: addresses
          .map((address) => Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(address.fullAddress),
                  subtitle: Text('CEP ${address.cep}'),
                ),
              ))
          .toList(),
    );
  }
}
