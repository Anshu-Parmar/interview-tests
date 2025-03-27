import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
        actionIcon: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.guestSettings),
              // {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => GuestSettingsMenu(),
              //       ));
              // },
              icon: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                      AppVectors.settings,
                      colorFilter: ColorFilter.mode(
                          context.isDarkMode
                              ? AppColors.lightBackgroundColor
                              : AppColors.darkBackgroundColor,
                          BlendMode.srcIn
                      ),
                  )
              )
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                      AppVectors.profile,
                      colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn
                      ),
                      fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(width: 25,),
                const Text(
                    'Guest User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            CustomElevatedButton(
                title: 'Log In',
                onPressed: () => Navigator.pushNamed(context, RouteNames.login,),
                // {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInPage()));
                // }
            ),
            const SizedBox(height: 30,),
            const Divider(),
            const SizedBox(height: 17,),

            const Text(
              'Access Following Features :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  Bookmark Articles'),
                  Text('•  Follow Publishers'),
                  Text('•  Customized Content')
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
