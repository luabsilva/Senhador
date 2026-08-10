import 'package:flutter/material.dart';

import '../themes/app_typography.dart';
import '../themes/cyber_theme.dart';
import 'scramble_text.dart';

class PasswordOutputBox extends StatelessWidget {
  final String password;
  final VoidCallback onCopy;
  final bool isEmpty;

  const PasswordOutputBox({
    super.key,
    required this.password,
    required this.onCopy,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CyberTheme.glassSurfaceDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isEmpty
                ? Text(
                    'Sua senha aparecerá aqui',
                    style: AppTypography.caption.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                  )
                : ScrambleText(text: password),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: isEmpty ? null : onCopy,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              elevation: 0,
              minimumSize: const Size(0, 44),
            ),
            child: Text(
              'Copiar',
              style: AppTypography.button,
            ),
          ),
        ],
      ),
    );
  }
}
