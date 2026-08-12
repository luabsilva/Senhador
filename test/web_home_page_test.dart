import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_key/domain/entities/generated_password.dart';
import 'package:cyber_key/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

    await tester.enterText(
        find.byType(TextFormField).first, 'MinhaSenhaForte2026');
    await tester.enterText(find.byType(TextFormField).at(1), 'gmail.com');

    final generateButton = find.widgetWithText(ElevatedButton, 'Gerar senha');
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
}
