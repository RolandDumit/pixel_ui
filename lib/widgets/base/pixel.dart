import 'dart:math';

import 'package:flutter/widgets.dart';

/// A [Pixel] is the smallest unit of a pixelated design.
/// It is a square that can be colored and sized.
///
class Pixel extends StatelessWidget {
  /// The minimum size of the pixel. This is to ensure that the pixel is visible.
  static const double minPixelSize = 5.0;

  /// The default spacing between pixels. This is used when [hasSpaceBetweenPixels] is true.
  static const double defaultPixelSpacing = 2.0;

  /// The color of the pixel. If null, the pixel will be transparent.
  final Color? color;

  /// The size of the pixel. If null, the pixel will be the minimum size.
  final double size;

  const Pixel({
    super.key,
    this.color,
    double? size,
  }) : size = size ?? minPixelSize;

  @override
  Widget build(BuildContext context) {
    final size = max(minPixelSize, this.size);

    return Container(
      width: size,
      height: size,
      color: color,
    );
  }
}
