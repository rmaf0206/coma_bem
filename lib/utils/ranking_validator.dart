String? validarRanking(String entrada) {
  final texto = entrada.trim();

  if (texto.isEmpty) {
    return 'O ranking é obrigatório.';
  }

  final ranking = int.tryParse(texto);

  if (ranking == null) {
    return 'O ranking deve ser um número inteiro.';
  }

  if (ranking < 1 || ranking > 5) {
    return 'O Ranking deve ser uma nota de 1 a 5!';
  }

  return null;
}