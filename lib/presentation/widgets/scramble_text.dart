import 'dart:async';

import 'package:flutter/material.dart';

class ScrambleText extends StatefulWidget {
  final String text;

  const ScrambleText({
    super.key,
    required this.text,
  });

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText> {
  late String _displayText;
  Timer? _timer;

  static const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%&*+-_=?';

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
  }

  @override
  void didUpdateWidget(covariant ScrambleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _animateScramble(widget.text);
    }
  }

  void _animateScramble(String target) {
    _timer?.cancel();
    final length = target.length;
    int frame = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (frame >= 12) {
        setState(() {
          _displayText = target;
        });
        timer.cancel();
        return;
      }

      final randomText = List.generate(length, (index) {
        final char = _chars[(frame + index) % _chars.length];
        return char;
      }).join();

      setState(() {
        _displayText = randomText;
      });
      frame++;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: const TextStyle(
        color: Color(0xFF10B981),
        fontFamily: 'FiraCode',
        fontSize: 20,
        letterSpacing: 1.2,
      ),
    );
  }
}
