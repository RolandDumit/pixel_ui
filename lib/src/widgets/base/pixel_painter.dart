import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The pixelation style to apply to the shape.
enum PixelationStyle {
  classic,
  bit16,
  bit8,
  minecraft,
}

/// A CustomPainter wrapper that draws a pixelated shape behind its child through [PixelPainter].
/// The pixelation style can be customized using the [style] property.
/// Use [PixelPainter] directly if you don't want a CustomPaint wrapper.
///
class PixelCustomPainter extends StatelessWidget {
  /// The color used to fill the shape.
  final Color fillColor;

  /// The offset for the shadow, creating a pixelated drop shadow effect.
  final double shadowOffset;

  /// The radius for rounded corners. Ignored for non-classic styles.
  final double cornerRadius;

  /// The pixelation style to apply to the shape.
  final PixelationStyle style;

  /// The color of the border around the shape.
  final Color borderColor;

  /// The color of the shadow behind the shape.
  final Color shadowColor;

  /// The width of the border around the shape.
  final double borderWidth;

  /// Whether to draw a bevel effect on the shape. Ignored for classic style.
  final bool drawBevel;

  /// The child widget to display on top of the painted shape.
  final Widget child;

  const PixelCustomPainter({
    super.key,
    required this.child,
    this.fillColor = Colors.white,
    this.shadowOffset = 4,
    this.cornerRadius = 8,
    this.style = PixelationStyle.minecraft,
    this.borderColor = Colors.black,
    this.shadowColor = Colors.black54,
    this.borderWidth = 2,
    this.drawBevel = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PixelPainter(
        fillColor: fillColor,
        shadowOffset: shadowOffset,
        cornerRadius: cornerRadius,
        style: style,
        borderColor: borderColor,
        shadowColor: shadowColor,
        borderWidth: borderWidth,
        drawBevel: drawBevel,
      ),
      child: child,
    );
  }
}

/// A CustomPainter that draws a pixelated shape based on the specified properties.
class PixelPainter extends CustomPainter {
  const PixelPainter({
    required this.fillColor,
    this.shadowOffset = 0,
    this.cornerRadius = 0,
    this.style = PixelationStyle.minecraft,
    this.borderColor = Colors.black,
    this.shadowColor = Colors.black,
    this.borderWidth = 2,
    this.drawBevel = true,
  });

  /// The color used to fill the shape.
  final Color fillColor;

  /// The offset for the shadow, creating a pixelated drop shadow effect.
  final double shadowOffset;

  /// The radius for rounded corners. Ignored for non-classic styles.
  final double cornerRadius;

  /// The pixelation style to apply to the shape.
  final PixelationStyle style;

  /// The color of the border around the shape.
  final Color borderColor;

  /// The color of the shadow behind the shape.
  final Color shadowColor;

  /// The width of the border around the shape.
  final double borderWidth;

  /// Whether to draw a bevel effect on the shape. Ignored for classic style.
  final bool drawBevel;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final Path shape = _shapePath(size);

    if (shadowOffset > 0 && shadowColor.alpha != 0) {
      final Paint shadowPaint = Paint()
        ..color = shadowColor
        ..isAntiAlias = false;
      canvas.save();
      canvas.translate(0, shadowOffset);
      canvas.drawPath(shape, shadowPaint);
      canvas.restore();
    }

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..isAntiAlias = false;
    canvas.drawPath(shape, fillPaint);

    if (drawBevel && style != PixelationStyle.classic) {
      _paintBevel(canvas, size);
    }

    if (borderWidth > 0 && borderColor.alpha != 0) {
      final Paint borderPaint = Paint()
        ..color = borderColor
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawPath(shape, borderPaint);
    }
  }

  void _paintBevel(Canvas canvas, Size size) {
    final double step = _stepForStyle(size);
    final double width = size.width - (step * 2);
    if (width <= 0 || size.height <= (step * 2)) {
      return;
    }

    final Paint lightPaint = Paint()
      ..color = Color.lerp(fillColor, Colors.white, 0.22) ?? fillColor
      ..isAntiAlias = false;
    final Paint darkPaint = Paint()
      ..color = Color.lerp(fillColor, Colors.black, 0.28) ?? fillColor
      ..isAntiAlias = false;

    canvas.drawRect(Rect.fromLTWH(step, step, width, step), lightPaint);
    canvas.drawRect(
      Rect.fromLTWH(step, size.height - (step * 2), width, step),
      darkPaint,
    );
  }

  Path _shapePath(Size size) {
    switch (style) {
      case PixelationStyle.classic:
        if (cornerRadius <= 0) {
          return Path()..addRect(Offset.zero & size);
        }
        final double radius = math.min(
          cornerRadius.roundToDouble(),
          math.min(size.width, size.height) / 2,
        );
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            Radius.circular(radius),
          ),
        );
      case PixelationStyle.bit16:
        return _steppedPath(size, requestedStep: 2, minecraftCorners: false);
      case PixelationStyle.bit8:
        return _steppedPath(size, requestedStep: 4, minecraftCorners: false);
      case PixelationStyle.minecraft:
        return _steppedPath(size, requestedStep: 3, minecraftCorners: true);
    }
  }

  Path _steppedPath(
    Size size, {
    required double requestedStep,
    required bool minecraftCorners,
  }) {
    final double w = size.width;
    final double h = size.height;
    if (w <= 2 || h <= 2) {
      return Path()..addRect(Offset.zero & size);
    }

    final double outer = _normalizeStep(requestedStep, size);
    final double inner = minecraftCorners
        ? math.min(
            outer * 2,
            math.max(outer, (math.min(w, h) / 2) - 1),
          )
        : outer;

    return Path()
      ..moveTo(inner, 0)
      ..lineTo(w - inner, 0)
      ..lineTo(w - outer, outer)
      ..lineTo(w - outer, inner)
      ..lineTo(w, inner)
      ..lineTo(w, h - inner)
      ..lineTo(w - outer, h - inner)
      ..lineTo(w - outer, h - outer)
      ..lineTo(w - inner, h)
      ..lineTo(inner, h)
      ..lineTo(outer, h - outer)
      ..lineTo(outer, h - inner)
      ..lineTo(0, h - inner)
      ..lineTo(0, inner)
      ..lineTo(outer, inner)
      ..lineTo(outer, outer)
      ..close();
  }

  double _stepForStyle(Size size) {
    switch (style) {
      case PixelationStyle.classic:
        return 1;
      case PixelationStyle.bit16:
        return _normalizeStep(2, size);
      case PixelationStyle.bit8:
        return _normalizeStep(4, size);
      case PixelationStyle.minecraft:
        return _normalizeStep(3, size);
    }
  }

  double _normalizeStep(double requestedStep, Size size) {
    final double maxStep = math.max(
      1.0,
      (math.min(size.width, size.height) / 4).floorToDouble(),
    );
    return math.min(requestedStep, maxStep);
  }

  @override
  bool shouldRepaint(covariant PixelPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        shadowOffset != oldDelegate.shadowOffset ||
        cornerRadius != oldDelegate.cornerRadius ||
        style != oldDelegate.style ||
        borderColor != oldDelegate.borderColor ||
        shadowColor != oldDelegate.shadowColor ||
        borderWidth != oldDelegate.borderWidth ||
        drawBevel != oldDelegate.drawBevel;
  }
}
