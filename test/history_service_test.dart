import 'package:flutter_test/flutter_test.dart';
import 'package:senhador/application/services/history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('mantém apenas os 20 parâmetros mais recentes', () async {
    final service = HistoryService();

    for (var index = 0; index < 21; index++) {
      await service.addParameter('param-$index');
    }

    final recent = await service.getRecentParameters();

    expect(recent, hasLength(20));
    expect(recent.first, 'param-20');
    expect(recent.last, 'param-1');
    expect(recent, isNot(contains('param-0')));
  });
}
