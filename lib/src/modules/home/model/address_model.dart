class AddressModel {
  const AddressModel({
    this.cep = '',
    this.logradouro = '',
    this.complemento = '',
    this.bairro = '',
    this.localidade = '',
    this.uf = '',
    this.ibge = '',
    this.ddd = '',
  });

  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String ddd;

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
        cep: map['cep']?.toString() ?? '',
        logradouro: map['logradouro']?.toString() ?? '',
        complemento: map['complemento']?.toString() ?? '',
        bairro: map['bairro']?.toString() ?? '',
        localidade: map['localidade']?.toString() ?? '',
        uf: map['uf']?.toString() ?? '',
        ibge: map['ibge']?.toString() ?? '',
        ddd: map['ddd']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'ibge': ibge,
        'ddd': ddd,
      };

  String get fullAddress {
    final parts = [
      logradouro,
      bairro,
      '$localidade - $uf',
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(', ');
  }
}
