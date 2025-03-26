import 'package:flutter/material.dart';
import '../core/services/force_update.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'homepage.dart';
import 'search.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Homepage(),
    Search(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timestamp) => checkForcedUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages.map((widget) => widget).toList(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onChanged: (index) {
          if (_currentIndex == index) return;
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
