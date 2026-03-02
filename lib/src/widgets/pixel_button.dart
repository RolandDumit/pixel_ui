import 'dart:math' as math;

import 'package:flutter/material.dart';

enum PixelationStyle {
  classic,
  bit16,
  bit8,
  minecraft,
}

class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF4CAF50),
    this.pressedColor = const Color(0xFF388E3C),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    this.cornerRadius = 0,
    this.pixelationStyle = PixelationStyle.minecraft,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color pressedColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double cornerRadius;
  final PixelationStyle pixelationStyle;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color fillColor = _isPressed ? widget.pressedColor : widget.backgroundColor;
    final double yOffset = _isPressed ? 2 : 4;

    return InkWell(
      onTap: widget.onPressed,
      onHighlightChanged: widget.onPressed == null
          ? null
          : (bool isHighlighted) {
              if (_isPressed != isHighlighted) {
                setState(() {
                  _isPressed = isHighlighted;
                });
              }
            },
      child: CustomPaint(
        painter: _PixelButtonPainter(
          fillColor: fillColor,
          shadowOffset: yOffset,
          cornerRadius: widget.cornerRadius,
          style: widget.pixelationStyle,
        ),
        child: Padding(
          padding: widget.padding,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PixelButtonPainter extends CustomPainter {
  const _PixelButtonPainter({
    required this.fillColor,
    required this.shadowOffset,
    required this.cornerRadius,
    required this.style,
  });

  final Color fillColor;
  final double shadowOffset;
  final double cornerRadius;
  final PixelationStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final Path shape = _shapePath(size);

    final Paint shadowPaint = Paint()
      ..color = Colors.black
      ..isAntiAlias = false;
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..isAntiAlias = false;
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (shadowOffset > 0) {
      canvas.save();
      canvas.translate(0, shadowOffset);
      canvas.drawPath(shape, shadowPaint);
      canvas.restore();
    }

    canvas.drawPath(shape, fillPaint);
    if (style != PixelationStyle.classic) {
      _paintBevel(canvas, size);
    }
    canvas.drawPath(shape, borderPaint);
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
    if (size.isEmpty) {
      return Path();
    }

    switch (style) {
      case PixelationStyle.classic:
        if (cornerRadius <= 0) {
          return Path()..addRect(Offset.zero & size);
        }
        final double radius = math
            .min(
              cornerRadius.roundToDouble(),
              math.min(size.width, size.height) / 2,
            )
            .toDouble();
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
        ? math
              .min(
                outer * 2,
                math.max(outer, (math.min(w, h) / 2) - 1),
              )
              .toDouble()
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
    final double maxStep = math
        .max(
          1.0,
          (math.min(size.width, size.height) / 4).floorToDouble(),
        )
        .toDouble();
    return math.min(requestedStep, maxStep).toDouble();
  }

  @override
  bool shouldRepaint(covariant _PixelButtonPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        shadowOffset != oldDelegate.shadowOffset ||
        cornerRadius != oldDelegate.cornerRadius ||
        style != oldDelegate.style;
  }
}
