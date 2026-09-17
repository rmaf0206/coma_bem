import 'package:flutter_test/flutter_test.dart';

import 'package:coma_bem/main.dart';

void main() {
  testWidgets(
    'Aplicativo Coma Bem inicia corretamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ComaBemApp(),
      );

      expect(
        find.text('Coma Bem'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Descubra, avalie e compartilhe\n'
          'os melhores restaurantes.',
        ),
        findsOneWidget,
      );

      await tester.pump(
        const Duration(seconds: 3),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Bem-vindo de volta!'),
        findsOneWidget,
      );

      expect(
        find.text('E-mail'),
        findsOneWidget,
      );

      expect(
        find.text('Senha'),
        findsOneWidget,
      );

      expect(
        find.text('Entrar'),
        findsOneWidget,
      );
    },
  );
}