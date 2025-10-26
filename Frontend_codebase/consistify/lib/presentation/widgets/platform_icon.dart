// lib/presentation/widgets/platform_icon.dart

import 'package:flutter/material.dart';
import 'package:consistify/core/constants/app_constants.dart';

class PlatformIcon extends StatelessWidget {
  final String platformName;
  final double size;

  const PlatformIcon({
    super.key,
    required this.platformName,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final String? iconPath = AppConstants.platformIconPaths[platformName];

    if (iconPath != null) {
      return Image.asset(
        iconPath,
        width: size,
        height: size,
      );
    } else {
      
      return Icon(Icons.code, size: size, color: Colors.grey);
    }
  }
}