import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/theme_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.read<ThemeProvider>();
    return Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(color: themeProvider.baseTheme.primaryText),
        ),
      ),
    );
  }
}
