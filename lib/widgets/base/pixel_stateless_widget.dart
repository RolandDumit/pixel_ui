import 'package:flutter/widgets.dart';

abstract class PixelStatelessWidget extends StatelessWidget {
  final Color? pixelColor;
  final double? pixelSize;
  final bool hasSpaceBetweenPixels;
  final double? spaceBetweenPixels;

  const PixelStatelessWidget({
    super.key,
    required this.pixelColor,
    required this.pixelSize,
    required this.hasSpaceBetweenPixels,
    required this.spaceBetweenPixels,
  });
}
