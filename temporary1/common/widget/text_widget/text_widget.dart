import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? textOverFlow;
  final bool fixedSize;
  final double fontAddSize;

  const TextWidget({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.textOverFlow,
    this.fixedSize = false,
    this.fontAddSize = 0
  });

  @override
  Widget build(BuildContext context) {
    ///COMMENTING FONT FAMILY AND FONT SIZE FUNCTIONALITY
    // return BlocBuilder<FontFamilyCubit, String?>(
    //   builder: (context, famState) {
        // return BlocBuilder<FontSizeCubit, double>(
        //   builder: (context, state) {
        //     if (!fixedSize) {
        //       fontSize = context.read<FontSizeCubit>().assignTextSize();
        //     }
            return Text(
              text,
              style: TextStyle(
                  fontSize: fontSize + fontAddSize,
                  // fontFamily: famState,
                  fontFamily: 'Mulish',
                  color: color,
                  fontWeight: fontWeight,
                  overflow: textOverFlow,
                  fontFamilyFallback: ['Mulish']
              ),
              overflow: textOverFlow,
              maxLines: maxLines,
            );
        //   },
        // );
    //   },
    // );
  }
}
