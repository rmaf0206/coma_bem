import 'package:flutter/material.dart';

class CampoFormularioCustomizando extends StatelessWidget {
  final String titulo;
  final TextEditingController controlador;
  final TextInputType tipoTeclado;
  final bool ocultarTexto;

const CampoFormularioCustomizando({
  Key? key,
  required this.titulo,
  required this.controlador,
  this.tipoTeclado = TextInputType.text,
  this.ocultarTexto = false,
}) : super(key: key);

@override
Widget build(BuildContext context) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextField(
      controller: controlador,
      keyboardType: tipoTeclado,
      obscureText: ocultarTexto,

      decoration: InputDecoration(
        labelText: titulo,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
        ),
      ),
    ),
  );
}
}