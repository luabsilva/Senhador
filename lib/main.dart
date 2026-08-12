import 'package:flutter/material.dart';

import 'presentation/pages/home_page.dart';
import 'presentation/themes/cyber_theme.dart';

void main() {
  runApp(const CyberKeyApp());
}

class CyberKeyApp extends StatelessWidget {
  const CyberKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyber_Key',
      theme: CyberTheme.theme,
      home: const HomePage(),
    );
  }
}
