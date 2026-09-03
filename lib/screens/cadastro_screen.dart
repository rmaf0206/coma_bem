import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../database/database_helper.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();
  final TextEditingController _nomePratoController = TextEditingController();
  final TextEditingController _rankingController = TextEditingController();
  final TextEditingController _recomendacoesController = TextEditingController();

  File? _fotoPrato;
  String _latitude = '';
  String _longitude = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(source: ImageSource.camera);
    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }

  Future<void> _pegarLocalizacao() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço de localização desativado.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de localização negada.')),
        );
        return;
      }
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = posicao.latitude.toString();
      _longitude = posicao.longitude.toString();
    });
  }

  void _salvarCadastro() async {
    Map<String, dynamic> dadosRestaurante = {
      'res_nm_restaurante': _nomeController.text,
      'res_ds_tipo_culinaria': _culinariaController.text,
      'res_nu_latitude': _latitude,
      'res_nu_longitude': _longitude,
    };

    await DatabaseHelper.instancia.inserirDados('restaurante', dadosRestaurante);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restaurante cadastrado!')),
    );
    Navigator.pop(context);
  }

  InputDecoration _estiloCampo(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Novo Cadastro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Color(0xFFD9411E),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: _estiloCampo('Nome do Restaurante', hintText: 'Ex: Sakura House'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _culinariaController,
              decoration: _estiloCampo('Tipo de Culinária', hintText: 'Ex: Japonesa'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _nomePratoController,
              decoration: _estiloCampo('Nome do Prato', hintText: 'Ex: Combo Temaki'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _rankingController,
              keyboardType: TextInputType.number,
              decoration: _estiloCampo('Ranking (Nota de 1 a 5)', hintText: 'Ex: 4.8'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _recomendacoesController,
              maxLines: 3,
              decoration: _estiloCampo('Recomendações / Sobre', hintText: 'Ambiente aconchegante...'),
            ),
            SizedBox(height: 20),
            Text(
              'Foto do Prato:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _fotoPrato != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_fotoPrato!, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Text(
                        'Nenhuma foto selecionada',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tirarFoto,
                icon: Icon(Icons.camera_alt, color: Color(0xFFD9411E)),
                label: Text(
                  'Tirar Foto do Prato',
                  style: TextStyle(color: Color(0xFFD9411E), fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  side: BorderSide(color: Color(0xFFD9411E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Localização GPS:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pegarLocalizacao,
                icon: Icon(Icons.location_on, color: Colors.black87),
                label: Text(
                  'Obter Localização',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            if (_latitude.isNotEmpty && _longitude.isNotEmpty) ...[
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Lat: $_latitude, Long: $_longitude',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _salvarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9411E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  'Salvar Cadastro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}