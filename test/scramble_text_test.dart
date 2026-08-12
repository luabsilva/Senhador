import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_key/presentation/widgets/scramble_text.dart';

void main() {
  testWidgets('anima e estabiliza o texto embaralhado',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScrambleText(text: 'ABC123'),
        ),
      ),
    );

    expect(find.text('ABC123'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScrambleText(text: 'XYZ789'),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 35));

    expect(find.text('XYZ789'), findsNothing);

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('XYZ789'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SizedBox.shrink()),
      ),
    );
    await tester.pump();
  });
}
