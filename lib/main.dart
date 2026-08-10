import 'package:flutter/material.dart';

import 'presentation/pages/home_page.dart';
import 'presentation/themes/cyber_theme.dart';

void main() {
  runApp(const SenhadorApp());
}

class SenhadorApp extends StatelessWidget {
  const SenhadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senhador',
      theme: CyberTheme.theme,
      home: const HomePage(),
    );
  }
}
