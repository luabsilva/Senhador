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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 320;
        final output = isEmpty
            ? Text(
                'Sua senha aparecerá aqui',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
              )
            : FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: ScrambleText(text: password),
              );

        return Container(
          decoration: CyberTheme.glassSurfaceDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    output,
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildCopyButton(),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: output),
                    const SizedBox(width: 12),
                    _buildCopyButton(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCopyButton() {
    return ElevatedButton(
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
    );
  }
}
