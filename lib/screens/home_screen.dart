import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _restaurantes = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  void _carregarRestaurantes() async {
    var dados = await DatabaseHelper.instancia.consultarDados('restaurante');
    setState(() {
      _restaurantes = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Coma Bem',
                style: TextStyle(
                  color: Color(0xFFD9411E),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Olá, Ricardo!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('🔥', style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar restaurantes...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Restaurantes visitados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: _restaurantes.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum restaurante encontrado.',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _restaurantes.length,
                        itemBuilder: (context, index) {
                          var item = _restaurantes[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['res_nm_restaurante'] ?? 'Sem nome',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    item['res_ds_tipo_culinaria'] ?? 'Culinária',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 14, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.6',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/comida.png',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey[200],
                                          child: Icon(Icons.restaurant, color: Colors.grey[400]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFFD9411E),
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarIcon(icon: Icons.home, label: 'Home'),
          BottomNavigationBarIcon(icon: Icons.search, label: 'Buscar'),
          BottomNavigationBarIcon(icon: Icons.star_border, label: 'Avaliações'),
          BottomNavigationBarIcon(icon: Icons.person_outline, label: 'Perfil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroScreen()),
          );
        },
        backgroundColor: Color(0xFFD9411E),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

BottomNavigationBarItem BottomNavigationBarIcon({required IconData icon, required String label}) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}