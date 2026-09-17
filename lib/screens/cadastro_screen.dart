import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../components/campo_formulario_customizando.dart';
import '../components/botao_customizado.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _culinariaController =
      TextEditingController();

  final TextEditingController _nomePratoController =
      TextEditingController();

  final TextEditingController _rankingController =
      TextEditingController();

  final TextEditingController _recomendacoesController =
      TextEditingController();

  File? _fotoPrato;

  String _latitude = '';
  String _longitude = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }

  Future<void> _pegarLocalizacao() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Serviço de localização desativado.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Permissão de localização negada.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Permissão de localização negada permanentemente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Position posicao =
        await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = posicao.latitude.toString();
      _longitude = posicao.longitude.toString();
    });
  }

  void _salvarCadastro() async {
    // Verifica os campos obrigatórios
    if (_nomeController.text.isEmpty ||
        _culinariaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, preencha os campos obrigatórios!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica se o Ranking foi preenchido
    if (_rankingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'O Ranking deve ser uma nota de 1 a 5!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Converte o Ranking de texto para número
      int ranking = int.parse(_rankingController.text);

      // Verifica se o Ranking está entre 1 e 5
      if (ranking < 1 || ranking > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'O Ranking deve ser uma nota de 1 a 5!',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Dados do restaurante
      Map<String, dynamic> dadosRestaurante = {
        'res_nm_restaurante': _nomeController.text,
        'res_ds_tipo_culinaria': _culinariaController.text,
        'res_nu_latitude': _latitude,
        'res_nu_longitude': _longitude,
      };

      await DatabaseHelper.instancia.inserirDados(
        'restaurante',
        dadosRestaurante,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Restaurante cadastrado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (erro) {
      print(
        'DEBUG - Erro ao salvar no SQLite: $erro',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro inesperado ao salvar.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Novo Cadastro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFD9411E),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Nome do restaurante
            CampoFormularioCustomizando(
              titulo: 'Nome do Restaurante',
              controlador: _nomeController,
            ),

            // Tipo de culinária
            CampoFormularioCustomizando(
              titulo: 'Tipo de Culinária',
              controlador: _culinariaController,
            ),

            // Nome do prato
            CampoFormularioCustomizando(
              titulo: 'Nome do Prato',
              controlador: _nomePratoController,
            ),

            // Ranking
            CampoFormularioCustomizando(
              titulo: 'Ranking (1 a 5)',
              controlador: _rankingController,
              tipoTeclado: TextInputType.number,
            ),

            SizedBox(height: 12),

            // Recomendações
            TextField(
              controller: _recomendacoesController,
              maxLines: 3,

              decoration: InputDecoration(
                labelText: 'Recomendações / Sobre',
                hintText: 'Ambiente aconchegante...',
                filled: true,
                fillColor: Colors.grey[100],

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Foto
            Text(
              'Foto do Prato:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 10),

            Container(
              height: 180,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.grey[100],

                borderRadius: BorderRadius.circular(8),

                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),

              child: _fotoPrato != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.file(
                        _fotoPrato!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        'Nenhuma foto selecionada',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ),
            ),

            SizedBox(height: 10),

            // Botão para tirar foto
            BotaoCustomizado(
              texto: 'Tirar Foto do Prato',
              onPressed: _tirarFoto,
              contorno: true,
              icone: Icons.camera_alt,
            ),

            SizedBox(height: 20),

            // Localização
            Text(
              'Localização GPS:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 10),

            // Botão localização
            BotaoCustomizado(
              texto: 'Obter Localização',
              onPressed: _pegarLocalizacao,
              contorno: true,
              icone: Icons.location_on,
            ),

            // Exibe localização
            if (_latitude.isNotEmpty &&
                _longitude.isNotEmpty) ...[
              SizedBox(height: 8),

              Center(
                child: Text(
                  'Lat: $_latitude, Long: $_longitude',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],

            SizedBox(height: 30),

            // Salvar
            BotaoCustomizado(
              texto: 'Salvar Cadastro',
              onPressed: _salvarCadastro,
            ),
          ],
        ),
      ),
    );
  }
}