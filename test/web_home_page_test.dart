import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senhador/domain/entities/generated_password.dart';
import 'package:senhador/presentation/pages/home_page.dart';

void main() {
  testWidgets('web browser generates and displays password correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (request) async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );

    expect(find.text('Parâmetro'), findsOneWidget);
    expect(find.text('Senha Mestra'), findsOneWidget);
    expect(find.text('Gerar senha'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'gmail.com');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'MinhaSenhaForte2026');

    await tester.tap(find.text('Gerar senha'));
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Processando...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Senha gerada'), findsOneWidget);
    expect(find.text('Q@9mL2#rX7!cNp4&'), findsOneWidget);
  });
}
