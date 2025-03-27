import 'package:flutter/material.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/short_name.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';

class ProfileContainerWidget extends StatelessWidget {
  final UserEntity? user;

  const ProfileContainerWidget({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
                height: 75,
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.lightBackgroundColor
                        : AppColors.darkBackgroundColor,
                    shape: BoxShape.circle),
                child: user == null
                    ? const CircularProgressIndicator()
                    : Container(
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            (user?.name ?? "Anonymous").toInitials(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: context.isDarkMode
                                  ? AppColors.darkBackgroundColor
                                  : AppColors.lightBackgroundColor,
                            ),
                          ),
                        ),
                    )),
            const SizedBox(
              width: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user == null
                    ? const SizedBox()
                    : SizedBox(
                        width: width,
                        child: Text(
                          user?.name ?? "Anonymous",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                user == null
                    ? const SizedBox()
                    : SizedBox(
                        width: width,
                        child: Text(
                          user?.email ?? "Anonymous",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                      )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
