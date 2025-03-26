import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/theme_provider.dart';

class CustomCupertinoSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? activeIcon;
  final Widget? inactiveIcon;

  const CustomCupertinoSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  State<CustomCupertinoSwitch> createState() => _CustomCupertinoSwitchState();
}

class _CustomCupertinoSwitchState extends State<CustomCupertinoSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.value ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant CustomCupertinoSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.animateTo(widget.value ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isActive = widget.value;
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          const thumbSize = 25.0;
          const switchWidth = 54.76;
          const switchHeight = 30.0;
          const padding = 2.0;

          final trackColor = themeProvider.baseTheme.surface;

          final thumbPosition = padding +
              (switchWidth - thumbSize - padding * 2) * _controller.value;

          return Container(
            width: switchWidth,
            height: switchHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(switchHeight / 2),
              color: trackColor,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: thumbPosition,
                  top: padding,
                  bottom: padding,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeProvider.baseTheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isActive ? widget.activeIcon : widget.inactiveIcon,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
