import 'package:material_ui/material_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobx/mobx.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../components/address_list_component.dart';
import '../components/empty_search_component.dart';
import '../components/last_address_component.dart';
import '../controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();
  final _cepController = TextEditingController();
  final _ufController = TextEditingController(text: 'SP');
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  ReactionDisposer? _errorReaction;

  @override
  void initState() {
    super.initState();
    _controller.loadLastAddress();
    _errorReaction = reaction(
      (_) => _controller.error.value,
      (String? message) {
        if (message != null && mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
    );
  }

  @override
  void dispose() {
    _errorReaction?.call();
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _traceRoute() async {
    final address = _controller.lastAddress.value;
    if (address == null) return;
    try {
      final locations = await locationFromAddress(address.fullAddress);
      if (locations.isEmpty) throw Exception('Localização não encontrada.');
      final maps = await MapLauncher.installedMaps;
      if (!mounted) return;
      if (maps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum aplicativo de mapas instalado.')),
        );
        return;
      }
      await maps.first.showDirections(
        destination: Coords(locations.first.latitude, locations.first.longitude),
        destinationTitle: address.fullAddress,
      );
    } catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exception.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('FastLocation'),
          actions: [
            IconButton(
              tooltip: 'Histórico',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.history),
              icon: const Icon(Icons.history),
            ),
          ],
          bottom: const TabBar(tabs: [
            Tab(text: 'Buscar CEP'),
            Tab(text: 'Buscar endereço'),
          ]),
        ),
        body: Observer(
          builder: (_) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_controller.lastAddress.value != null)
                    LastAddressComponent(
                      address: _controller.lastAddress.value!,
                      onRoute: _traceRoute,
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 170,
                    child: TabBarView(
                      children: [
                        _CepSearch(
                          controller: _cepController,
                          onSearch: () =>
                              _controller.searchByCep(_cepController.text),
                        ),
                        _AddressSearch(
                          ufController: _ufController,
                          cityController: _cityController,
                          streetController: _streetController,
                          onSearch: () => _controller.searchByAddress(
                            uf: _ufController.text,
                            city: _cityController.text,
                            street: _streetController.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_controller.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_controller.hasSearched.value &&
                      _controller.results.isEmpty &&
                      _controller.error.value == null)
                    const EmptySearchComponent()
                  else
                    AddressListComponent(
                        addresses: _controller.results.toList()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CepSearch extends StatelessWidget {
  const _CepSearch({required this.controller, required this.onSearch});
  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'CEP',
            hintText: 'Ex.: 01001000',
            prefixIcon: Icon(Icons.pin_drop_outlined),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onSearch,
          icon: const Icon(Icons.search),
          label: const Text('Consultar CEP'),
        ),
      ],
    );
  }
}

class _AddressSearch extends StatelessWidget {
  const _AddressSearch({
    required this.ufController,
    required this.cityController,
    required this.streetController,
    required this.onSearch,
  });
  final TextEditingController ufController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          SizedBox(
            width: 72,
            child: TextField(
              controller: ufController,
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                  labelText: 'UF', counterText: '', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                  labelText: 'Cidade', border: OutlineInputBorder()),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: streetController,
          decoration: const InputDecoration(
              labelText: 'Rua ou trecho',
              prefixIcon: Icon(Icons.route),
              border: OutlineInputBorder()),
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onSearch,
            icon: const Icon(Icons.search),
            label: const Text('Consultar endereço'),
          ),
        ),
      ],
    );
  }
}
