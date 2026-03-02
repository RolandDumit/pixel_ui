import 'package:flutter/material.dart';

import '../utils/pixel_colors.dart';
import 'base/pixel_painter.dart';

export 'base/pixel_painter.dart' show PixelationStyle;

class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = PixelColors.pixelColor,
    this.pressedColor = PixelColors.pressedPixelColor,
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
      child: PixelCustomPainter(
        fillColor: fillColor,
        shadowOffset: yOffset,
        cornerRadius: widget.cornerRadius,
        style: widget.pixelationStyle,
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
