import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senhador/presentation/pages/home_page.dart';
import 'package:senhador/domain/entities/generated_password.dart';
import 'package:senhador/domain/entities/password_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('exibe loading durante a geração de senha',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (PasswordRequest request) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );

    final parameterField = find.text('Parâmetro');
    final masterPasswordField = find.text('Senha Mestra');
    final generateButton = find.text('Gerar senha');

    expect(parameterField, findsOneWidget);
    expect(masterPasswordField, findsOneWidget);
    expect(generateButton, findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'gmail.com');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'MinhaSenhaForte2026');

    await tester.tap(generateButton);
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Processando...'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton).first).enabled,
        isFalse);

    await tester.pumpAndSettle();

    expect(find.text('Senha gerada'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });

  testWidgets('armazena o parâmetro recente após gerar senha',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (PasswordRequest request) async {
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'github.com');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'MinhaSenhaForte2026');

    await tester.tap(find.text('Gerar senha'));
    await tester.pumpAndSettle();

    expect(find.text('Recentes'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ActionChip &&
            widget.label is Text &&
            (widget.label as Text).data == 'github.com',
      ),
      findsOneWidget,
    );

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('recent_parameters'), ['github.com']);
  });
}
