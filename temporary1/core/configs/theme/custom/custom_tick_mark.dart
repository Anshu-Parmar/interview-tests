import 'package:flutter/material.dart';

class CustomTickMarkShape extends SliderTickMarkShape {

  @override
  Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled}) {
    return Size(1.0, 10.0);
  }

  @override
  void paint(PaintingContext context, Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required bool isEnabled,
    required TextDirection textDirection
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final int tickCount = 11;
    final double width = sliderTheme.trackHeight ?? 300.0;
    final double spaceBetweenTicks = width / (tickCount - 1);

    for (int i = 0; i < tickCount; i++) {
      final double x = center.dx + (i * spaceBetweenTicks);
      final double y = center.dy;


      canvas.drawRect(
        Rect.fromLTWH(x - 1.5, y - 6, 3.0, 12.0),
        paint,
      );
    }
  }
}