import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/common/widget/rate_my_app/rate_app_init.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/presentation/settings/widget/about_us_widget.dart';

class GuestSettingsMenu extends StatelessWidget {
  const GuestSettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['Display', 'About', 'Rate Start-O-Preneur'];

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0,10,16.0,16.0),
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
                // onPressed: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInPage()));
                // }
            ),

            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Divider(),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Navigator.pushNamed(context, RouteNames.displaySetting);
                          case 1:
                            CustomAboutUsModalSheet.showModelBottomSheet(context);
                          case 2:
                            RateAppInitWidget.showReviewDialog(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          options[index],
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, fontFamily: 'Mulish'),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          grade: 3,
                        ),
                      ),
                    );
                  },
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
