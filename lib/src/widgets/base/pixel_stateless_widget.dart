import 'package:flutter/widgets.dart';

import 'pixel_painter.dart';

abstract class PixelStatelessWidget extends StatelessWidget {
  final Color? pixelColor;
  final double? pixelSize;
  final PixelationStyle pixelationStyle;
  final bool hasSpaceBetweenPixels;
  final double? spaceBetweenPixels;
  final double? cornerRadius;

  /// Border color for the pixel. If null, the border is not drawn.
  final Color? pixelBorderColor;

  /// Border width for the pixel. If null, the border is not drawn.
  final double? pixelBorderWidth;

  /// Shadow color for the pixel. If null, the shadow is not drawn.
  final Color? pixelShadowColor;

  /// Shadow offset for the pixel. If null, the shadow is not drawn.
  final double? pixelShadowOffset;

  const PixelStatelessWidget({
    super.key,
    required this.pixelColor,
    required this.pixelSize,
    required this.pixelationStyle,
    required this.hasSpaceBetweenPixels,
    required this.spaceBetweenPixels,
    required this.cornerRadius,
    required this.pixelBorderColor,
    required this.pixelBorderWidth,
    required this.pixelShadowColor,
    required this.pixelShadowOffset,
  });
}
