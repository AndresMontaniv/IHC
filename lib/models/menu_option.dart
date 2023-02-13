import 'package:flutter/material.dart' show IconData, Widget;

class MenuOption {
  final String route;
  final String name;
  final Widget screen;
  final IconData icon;

  MenuOption({
    required this.route,
    required this.icon,
    required this.name,
    required this.screen,
  });
}
