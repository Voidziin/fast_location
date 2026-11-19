import 'package:flutter_test/flutter_test.dart';
import 'package:fast_location/src/modules/home/model/address_model.dart';

void main() {
  test('AddressModel parses ViaCEP data', () {
    final address = AddressModel.fromMap({
      'cep': '01001-000',
      'logradouro': 'Praça da Sé',
      'bairro': 'Sé',
      'localidade': 'São Paulo',
      'uf': 'SP',
    });

    expect(address.cep, '01001-000');
    expect(address.fullAddress, 'Praça da Sé, Sé, São Paulo - SP');
  });
}
