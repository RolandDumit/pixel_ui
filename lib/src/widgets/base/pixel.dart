import 'dart:math';

import 'package:flutter/widgets.dart';

import 'pixel_painter.dart';

/// A [Pixel] is the smallest unit of a pixelated design.
/// It is a square that can be colored and sized.
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

  /// Border color for the pixel. If null, the border is not drawn.
  final Color? borderColor;

  /// Border width for the pixel. If null, the border is not drawn.
  final double? borderWidth;

  /// Shadow color for the pixel. If null, the shadow is not drawn.
  final Color? shadowColor;

  /// Shadow offset for the pixel. If null, the shadow is not drawn.
  final double? shadowOffset;

  const Pixel({
    super.key,
    this.color,
    double? size,
    this.style = PixelationStyle.minecraft,
    this.cornerRadius = 8,
    this.borderColor,
    this.borderWidth,
    this.shadowColor,
    this.shadowOffset,
  }) : size = size ?? minPixelSize;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = max(minPixelSize, size);
    final resolvedColor = color ?? const Color(0x00000000);
    final resolvedCornerRadius = style == PixelationStyle.classic ? cornerRadius : 0.0;
    final hasBorder = borderColor != null && borderWidth != null && borderWidth! > 0;
    final hasShadow = shadowColor != null && shadowOffset != null && shadowOffset! > 0;

    return SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: PixelCustomPainter(
        fillColor: resolvedColor,
        shadowOffset: hasShadow ? shadowOffset! : 0,
        cornerRadius: resolvedCornerRadius,
        style: style,
        borderColor: hasBorder ? borderColor! : const Color(0x00000000),
        shadowColor: hasShadow ? shadowColor! : const Color(0x00000000),
        borderWidth: hasBorder ? borderWidth! : 0,
        drawBevel: false, // Pixel should render as a flat unit by default.
        child: const SizedBox.expand(),
      ),
    );
  }
}
