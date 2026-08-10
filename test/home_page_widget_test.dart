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

    await tester.pumpAndSettle();

    final parameterField = find.text('Parâmetro');
    final masterPasswordField = find.text('Senha Mestra');
    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');

    expect(parameterField, findsOneWidget);
    expect(masterPasswordField, findsOneWidget);
    expect(generateButton, findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'gmail.com');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'MinhaSenhaForte2026');

    await tester.ensureVisible(generateButton);
    await tester.tap(generateButton);
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(generateButton, findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(generateButton).onPressed,
      isNull,
    );

    await tester.pumpAndSettle();

    expect(find.text('Q@9mL2#rX7!cNp4&'), findsOneWidget);
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

    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'github.com');

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');
    await tester.ensureVisible(generateButton);
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(find.text('Parâmetros recentes'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ActionChip &&
            widget.label is Text &&
            (widget.label as Text).data == 'github.com',
      ),
      findsOneWidget,
    );

    final recentChip = find.byWidgetPredicate(
      (widget) =>
          widget is ActionChip &&
          widget.label is Text &&
          (widget.label as Text).data == 'github.com',
    );
    await tester.ensureVisible(recentChip);
    await tester.tap(recentChip);
    await tester.pump();

    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(1))
          .controller
          ?.text,
      'github.com',
    );

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('recent_parameters'), ['github.com']);
  });

  testWidgets('gera senha ao submeter os campos pelo teclado',
      (WidgetTester tester) async {
    var generatedRequests = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (PasswordRequest request) async {
            generatedRequests++;
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(1), 'github.com');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(generatedRequests, 1);
    expect(find.text('Q@9mL2#rX7!cNp4&'), findsOneWidget);
  });

  testWidgets('expande opções, altera controles e copia senha gerada',
      (WidgetTester tester) async {
    late PasswordRequest capturedRequest;

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (PasswordRequest request) async {
            capturedRequest = request;
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    final optionsTile =
        find.widgetWithText(ExpansionTile, 'Opções de caracteres');
    await tester.ensureVisible(optionsTile);
    await tester.tap(optionsTile);
    await tester.pumpAndSettle();

    expect(find.text('Maiúsculas'), findsOneWidget);
    expect(find.text('Minúsculas'), findsOneWidget);
    expect(find.text('Números'), findsOneWidget);
    expect(find.text('Símbolos'), findsOneWidget);

    final switches = find.byType(Switch);
    expect(switches, findsNWidgets(4));

    await tester.ensureVisible(switches.at(0));
    await tester.tap(switches.at(0));
    await tester.pump();
    await tester.ensureVisible(switches.at(1));
    await tester.tap(switches.at(1));
    await tester.pump();
    await tester.ensureVisible(switches.at(2));
    await tester.tap(switches.at(2));
    await tester.pump();
    await tester.ensureVisible(switches.at(3));
    await tester.tap(switches.at(3));
    await tester.pump();

    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(120, 0));
    await tester.pump();

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'github.com');

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');
    await tester.ensureVisible(generateButton);
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(capturedRequest.parameter, 'github.com');
    expect(capturedRequest.length, isNot(16));
    expect(capturedRequest.includeUppercase, isFalse);
    expect(capturedRequest.includeLowercase, isFalse);
    expect(capturedRequest.includeNumbers, isFalse);
    expect(capturedRequest.includeSymbols, isFalse);

    final copyButton = find.widgetWithText(ElevatedButton, 'Copiar');
    expect(copyButton, findsOneWidget);
    await tester.ensureVisible(copyButton);
    await tester.tap(copyButton);
    await tester.pump();

    expect(find.text('Senha copiada para a área de transferência.'),
        findsOneWidget);
  });
}
