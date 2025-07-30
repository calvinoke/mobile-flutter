import 'package:flutter/material.dart';

class PanelItem {
  final String title;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final double fontSize;
  final Widget page;

  const PanelItem({
    required this.title,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    required this.fontSize,
    required this.page,
  });
}

