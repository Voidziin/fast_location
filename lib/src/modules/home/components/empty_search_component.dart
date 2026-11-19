import 'package:material_ui/material_ui.dart';

class EmptySearchComponent extends StatelessWidget {
  const EmptySearchComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 56, color: Color(0xFF667085)),
          SizedBox(height: 12),
          Text('Nenhum endereço encontrado',
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('Confira os dados e tente novamente.',
              style: TextStyle(color: Color(0xFF667085))),
        ],
      ),
    );
  }
}
