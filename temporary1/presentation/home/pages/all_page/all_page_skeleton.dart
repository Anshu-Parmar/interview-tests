import 'package:flutter/material.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class AllPageSkeleton extends StatelessWidget {
  const AllPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
              ),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          ),
        ],
      ),
    );
  }
}
