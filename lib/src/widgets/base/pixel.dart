import 'dart:math';

import 'package:flutter/widgets.dart';

import 'pixel_painter.dart';

/// A [Pixel] is the smallest unit of a pixelated design.
/// It is a square that can be colored and sized.
// TODO: Add the possibility to add a border to the pixel, and a shadow. They'll remain null and not be drawn if not specified, but if specified, they should be drawn with the correct colors and sizes.
class Pixel extends StatelessWidget {
  /// The minimum size of the pixel. This is to ensure that the pixel is visible.
  static const double minPixelSize = 5.0;

  /// The default spacing between pixels. This is used when [hasSpaceBetweenPixels] is true.
  static const double defaultPixelSpacing = 2.0;

  /// The color of the pixel. If null, the pixel will be transparent.
  final Color? color;

  /// The size of the pixel. If null, the pixel will be the minimum size.
  final double size;

  /// The pixelation style to use when drawing the pixel.
  final PixelationStyle style;

  /// The corner radius applied only when [style] is [PixelationStyle.classic].
  final double cornerRadius;

  const Pixel({
    super.key,
    this.color,
    double? size,
    this.style = PixelationStyle.minecraft,
    this.cornerRadius = 8,
  }) : size = size ?? minPixelSize;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = max(minPixelSize, size);
    final resolvedColor = color ?? const Color(0x00000000);
    final resolvedCornerRadius = style == PixelationStyle.classic ? cornerRadius : 0.0;

    return SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: PixelCustomPainter(
        fillColor: resolvedColor,
        style: style,
        cornerRadius: resolvedCornerRadius,
        borderWidth: 0,
        shadowOffset: 0,
        drawBevel: false,
        child: const SizedBox.expand(),
      ),
    );
  }
}
