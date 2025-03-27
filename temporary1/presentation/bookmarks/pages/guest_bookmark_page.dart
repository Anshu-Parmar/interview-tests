import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class GuestBookmarkPage extends StatelessWidget {
  const GuestBookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bookmarks',

        ///NOTIFICATION ICON IMPLEMENTATION
        // actionIcon: Padding(
        //   padding: const EdgeInsets.only(right: 15.0),
        //   child: IconButton(
        //       onPressed: () {
        //         // Navigator.pop(context);
        //       },
        //       icon: Container(
        //           decoration: const BoxDecoration(
        //             // color: context.isDarkMode ?  Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.04),
        //               shape: BoxShape.circle),
        //           child: SvgPicture.asset(AppVectors.notification))),
        // ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutralOffWhiteColor, width: 4),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppVectors.bookmark,
                    colorFilter: ColorFilter.mode(AppColors.neutralOffWhiteColor, BlendMode.srcIn),
                    semanticsLabel: "bookmark",
                    height: 50,
                  ),
                ),
                Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        "To access your bookmarks",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.clip, height: 1.7),
                      ),
                      Text(
                        "Log In into your account",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.clip, height: 1.7),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  title: "Log In",
                  onPressed: () => Navigator.pushNamed(context, RouteNames.login,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
