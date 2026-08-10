import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _recentParametersKey = 'recent_parameters';
  static const int _maxEntries = 20;

  Future<List<String>> getRecentParameters() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_recentParametersKey) ?? <String>[];

    return stored
        .where((parameter) => parameter.trim().isNotEmpty)
        .toList(growable: false);
  }

  Future<void> addParameter(String parameter) async {
    final normalized = parameter.trim();
    if (normalized.isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final current = await getRecentParameters();
    final updated = current
        .where((item) => item != normalized)
        .toList(growable: true)
      ..insert(0, normalized);

    if (updated.length > _maxEntries) {
      updated.removeRange(_maxEntries, updated.length);
    }

    await prefs.setStringList(_recentParametersKey, updated);
  }
}
