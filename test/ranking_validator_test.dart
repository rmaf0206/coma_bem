import 'package:flutter_test/flutter_test.dart';
import 'package:coma_bem/utils/ranking_validator.dart';

void main() {
  group('Validação do ranking - Coma Bem', () {

    test('CT-001 - deve aceitar a nota mínima 1', () {
      expect(
        validarRanking('1'),
        isNull,
      );
    });

    test('CT-002 - deve aceitar a nota máxima 5', () {
      expect(
        validarRanking('5'),
        isNull,
      );
    });

    test('CT-003 - deve aceitar uma nota intermediária 3', () {
      expect(
        validarRanking('3'),
        isNull,
      );
    });

    test('CT-004 - deve rejeitar a nota 0', () {
      expect(
        validarRanking('0'),
        isNotNull,
      );
    });

    test('CT-005 - deve rejeitar a nota 6', () {
      expect(
        validarRanking('6'),
        isNotNull,
      );
    });

    test('CT-006 - deve rejeitar texto', () {
      expect(
        validarRanking('abc'),
        isNotNull,
      );
    });

    test('CT-007 - deve rejeitar entrada vazia', () {
      expect(
        validarRanking(''),
        isNotNull,
      );
    });

    test('CT-008 - deve aceitar nota com espaços laterais', () {
      expect(
        validarRanking(' 4 '),
        isNull,
      );
    });
  });
}