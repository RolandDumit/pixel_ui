import 'package:flutter/widgets.dart';

import 'base/pixel.dart';
import 'base/pixel_stateless_widget.dart';

class PixelLinearProgressIndicator extends PixelStatelessWidget {
  final double progress;
  final int totalPixels;
  final Color? backgroundPixelColor;

  const PixelLinearProgressIndicator({
    super.key,
    super.pixelColor,
    super.pixelSize,
    super.hasSpaceBetweenPixels = true,
    super.spaceBetweenPixels = Pixel.defaultPixelSpacing,
    this.progress = 0,
    this.totalPixels = 24,
    this.backgroundPixelColor,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    final resolvedPixelSize = pixelSize ?? Pixel.minPixelSize;
    final resolvedPixelColor = pixelColor ?? const Color(0xFF2ECC71);
    final resolvedBackgroundColor = backgroundPixelColor ?? const Color(0xFF2D3436);
    final filledPixels = (totalPixels * clampedProgress).round();

    return Row(
      spacing: hasSpaceBetweenPixels ? spaceBetweenPixels ?? Pixel.defaultPixelSpacing : 0,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalPixels,
        (index) => Pixel(
          size: resolvedPixelSize,
          color: index < filledPixels ? resolvedPixelColor : resolvedBackgroundColor,
        ),
      ),
    );
  }
}
