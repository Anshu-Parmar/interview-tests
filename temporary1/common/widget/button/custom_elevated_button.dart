import 'package:flutter/material.dart';
import 'package:startopreneur/common/widget/debouce/single_tap.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool useSingleTap;
  final bool transparentBackground;
  final Color borderColor;
  final double? elevation;

  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.useSingleTap = true,
    this.transparentBackground = false,
    this.borderColor = AppColors.primaryColor,
    this.elevation
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if(useSingleTap) {
            if (SingleTapDetector.isClicked == false) {
              SingleTapDetector.startTimer();
              SingleTapDetector.isClicked = true;
              onPressed();
            }
          } else {
            onPressed();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          minimumSize: const Size.fromHeight(47),
          backgroundColor: transparentBackground ? AppColors.lightBackgroundColor : AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: borderColor)
          )
        ),
        child: Text(
          title,
          style: TextStyle(
            color: transparentBackground
                ? borderColor
                : AppColors.lightBackgroundColor,
          ),
        )
    );
  }
}
