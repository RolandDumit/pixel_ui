import 'package:flutter/widgets.dart';

import 'pixel_painter.dart';

abstract class PixelStatelessWidget extends StatelessWidget {
  final Color? pixelColor;
  final double? pixelSize;
  final PixelationStyle pixelationStyle;
  final bool hasSpaceBetweenPixels;
  final double? spaceBetweenPixels;
  final double? cornerRadius;

  const PixelStatelessWidget({
    super.key,
    required this.pixelColor,
    required this.pixelSize,
    required this.pixelationStyle,
    required this.hasSpaceBetweenPixels,
    required this.spaceBetweenPixels,
    required this.cornerRadius,
  });
}
