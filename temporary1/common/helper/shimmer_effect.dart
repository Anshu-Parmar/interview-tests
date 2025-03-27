import 'dart:developer';

import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    log("ANIMATION CONTROLLER INITIATED");

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    log("ANIMATION CONTROLLER DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.3, 0.5, 0.7],
              colors: [
                Colors.grey.withValues(alpha: 0.3),
                Colors.grey.withValues(alpha: 0.5),
                Colors.grey.withValues(alpha: 0.3),
              ],
              transform: ShimmerGradientTransform(_animation.value),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerGradientTransform extends GradientTransform {
  final double offset;

  const ShimmerGradientTransform(this.offset);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      offset * bounds.width,
      offset * bounds.height,
      0.0,
    );
  }
}
