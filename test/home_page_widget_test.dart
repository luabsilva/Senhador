import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_key/domain/entities/generated_password.dart';
import 'package:cyber_key/domain/entities/password_request.dart';
import 'package:cyber_key/presentation/pages/home_page.dart';
import 'package:cyber_key/presentation/widgets/glass_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('preenche a área útil e reduz com o teclado',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    final fullHeight = tester.getSize(find.byType(GlassContainer)).height;
    expect(fullHeight, 1168);

    final masterPasswordField = find.byType(TextFormField).first;
    final masterPasswordElement = tester.element(masterPasswordField);
    await tester.tap(masterPasswordField);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);

    tester.view.viewInsets = const FakeViewPadding(bottom: 400);
    await tester.pumpAndSettle();

    final reducedHeight = tester.getSize(find.byType(GlassContainer)).height;
    expect(reducedHeight, 768);
    expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);
    expect(tester.element(masterPasswordField), same(masterPasswordElement));
  });

  testWidgets('adapta os componentes a uma largura estreita',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          generatePassword: (request) async {
            return const GeneratedPassword(
              value: 'Q@9mL2#rX7!cNp4&',
              strengthScore: 4,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('v1.0.1'), findsOneWidget);
    expect(find.byTooltip('Configurações'), findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'gmail.com');

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');
    await tester.ensureVisible(generateButton);
    await tester.tap(generateButton);
    await tester.pumpAndSettle();

    expect(find.text('Q@9mL2#rX7!cNp4&'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Copiar'), findsOneWidget);
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

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');

    expect(find.text('Parâmetro'), findsOneWidget);
    expect(find.text('Senha Mestra'), findsOneWidget);
    expect(generateButton, findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'gmail.com');

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

  testWidgets('exibe parâmetros recentes na combobox editável',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'recent_parameters': ['github.com', 'gmail.com'],
    });

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

    final parameterField = find.byType(TextFormField).at(1);
    final parameterOptionsButton =
        find.byTooltip('Mostrar parâmetros recentes');

    await tester.tap(parameterOptionsButton);
    await tester.pumpAndSettle();

    expect(find.text('Parâmetros recentes'), findsNothing);
    expect(find.text('github.com'), findsOneWidget);
    expect(find.text('gmail.com'), findsOneWidget);

    await tester.tap(parameterOptionsButton);
    await tester.pumpAndSettle();

    expect(find.text('github.com'), findsNothing);
    expect(find.text('gmail.com'), findsNothing);

    await tester.tap(parameterField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('github.com'));
    await tester.pump();

    expect(
      tester.widget<TextFormField>(parameterField).controller?.text,
      'github.com',
    );
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

  testWidgets('abre configurações e aplica opções à solicitação',
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

    expect(find.text('v1.0.1'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNothing);

    await tester.tap(find.byTooltip('Configurações'));
    await tester.pumpAndSettle();

    expect(find.text('Configurações'), findsOneWidget);
    expect(find.text('Comprimento da senha'), findsOneWidget);
    expect(find.text('Maiúsculas'), findsOneWidget);
    expect(find.text('Minúsculas'), findsOneWidget);
    expect(find.text('Números'), findsOneWidget);
    expect(find.text('Símbolos'), findsOneWidget);

    final switches = find.byType(Switch);
    expect(switches, findsNWidgets(4));

    for (var index = 0; index < 4; index++) {
      await tester.ensureVisible(switches.at(index));
      await tester.tap(switches.at(index));
      await tester.pump();
    }

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'github.com');

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');
    await tester.ensureVisible(generateButton);
    await tester.tap(generateButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(capturedRequest.parameter, 'github.com');
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
