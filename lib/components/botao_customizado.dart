import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool contorno;
  final IconData? icone;

  const BotaoCustomizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.contorno = false,
    this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color corPrincipal = Color(0xFFD9411E);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              contorno ? Colors.white : corPrincipal,
          foregroundColor: corPrincipal,
          elevation: 0,
          side: contorno
              ? const BorderSide(
                  color: corPrincipal,
                  width: 1.5,
                )
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icone != null) ...[
              Icon(
                icone,
                color: contorno ? corPrincipal : Colors.white,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              texto,
              style: TextStyle(
                color: contorno ? corPrincipal : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}