import 'package:flutter/material.dart';

import '../themes/app_typography.dart';
import '../themes/cyber_theme.dart';

class StrengthMeter extends StatelessWidget {
  final int score;

  const StrengthMeter({
    super.key,
    required this.score,
  });

  Color get _activeColor {
    if (score <= 1) {
      return const Color(0xFFEF4444);
    }
    if (score == 2) {
      return const Color(0xFFF59E0B);
    }
    return CyberTheme.emeraldPrimary;
  }

  String get _label {
    switch (score) {
      case 4:
        return 'Muito Forte';
      case 3:
        return 'Forte';
      case 2:
        return 'Média';
      default:
        return 'Fraca';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(4, (index) {
              final active = score > index;
              return Expanded(
                child: Container(
                  height: 10,
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: active ? _activeColor : const Color(0xFF0D1A12),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Força da senha',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _label,
                style: AppTypography.caption.copyWith(color: _activeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
