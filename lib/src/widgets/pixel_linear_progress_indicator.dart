import 'package:flutter/widgets.dart';

import '../utils/pixel_colors.dart';
import 'base/pixel.dart';
import 'base/pixel_painter.dart' show PixelationStyle;
import 'base/pixel_stateless_widget.dart';

class PixelLinearProgressIndicator extends PixelStatelessWidget {
  final double progress;
  final int totalPixels;
  final Color? backgroundPixelColor;

  const PixelLinearProgressIndicator({
    super.key,
    super.pixelColor,
    super.pixelSize,
    super.pixelationStyle = PixelationStyle.minecraft,
    super.hasSpaceBetweenPixels = true,
    super.spaceBetweenPixels = Pixel.defaultPixelSpacing,
    super.cornerRadius = 0,
    this.progress = 0,
    this.totalPixels = 24,
    this.backgroundPixelColor,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    final resolvedPixelSize = pixelSize ?? Pixel.minPixelSize;
    final resolvedPixelColor = pixelColor ?? PixelColors.pixelColor;
    final resolvedBackgroundColor = backgroundPixelColor ?? PixelColors.deactivatedPixelColor;
    final filledPixels = (totalPixels * clampedProgress).round();

    return Row(
      spacing: hasSpaceBetweenPixels ? spaceBetweenPixels ?? Pixel.defaultPixelSpacing : 0,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalPixels,
        (index) => Pixel(
          size: resolvedPixelSize,
          color: index < filledPixels ? resolvedPixelColor : resolvedBackgroundColor,
          style: pixelationStyle,
          cornerRadius: cornerRadius ?? 0,
        ),
      ),
    );
  }
}
