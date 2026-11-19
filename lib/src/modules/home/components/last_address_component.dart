import 'package:material_ui/material_ui.dart';

import '../model/address_model.dart';

class LastAddressComponent extends StatelessWidget {
  const LastAddressComponent({
    super.key,
    required this.address,
    required this.onRoute,
  });
  final AddressModel address;
  final VoidCallback onRoute;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEAF2FF),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.place, color: Color(0xFF0F6BFF)),
        title: const Text('Último endereço consultado',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${address.fullAddress}\nCEP ${address.cep}'),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: 'Traçar rota',
          onPressed: onRoute,
          icon: const Icon(Icons.directions),
        ),
      ),
    );
  }
}
