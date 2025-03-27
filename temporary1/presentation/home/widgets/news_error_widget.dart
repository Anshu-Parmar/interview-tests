import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class NewsErrorWidget extends StatelessWidget {
  final String channelName;
  final VoidCallback onRefresh;
  const NewsErrorWidget({super.key, required this.channelName, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppVectors.noNews,
            fit: BoxFit.scaleDown,
            height: 150,
          ),
          const SizedBox(height: 10,),
          IconButton(
              onPressed: () => onRefresh,
              color: AppColors.primaryColor,
              style: IconButton.styleFrom(
                  shape: CircleBorder(
                      side: BorderSide(color: AppColors.primaryColor)
                  )
              ),
              constraints: BoxConstraints(),
              iconSize: 40,
              padding: EdgeInsets.all(20),
              splashColor: Colors.red,
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.refresh, size: 40,)
          ),
          const SizedBox(
            height: 20,
          ),
          Text(AppTexts.noNews, style: TextStyle(decoration: TextDecoration.underline),),
          const SizedBox(height: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppTexts.noNewsDescription),
              Text(channelName),
              Text(AppTexts.noNewsDescription2),
            ],
          )
        ],
      ),
    );
  }
}
