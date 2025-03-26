import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/theme_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: Center(
        child: Text(
          'Homepage',
          style: TextStyle(color: themeProvider.baseTheme.primaryText),
        ),
      ),
    );
  }
}
