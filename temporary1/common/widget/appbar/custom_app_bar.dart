import 'package:flutter/material.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actionIcon;
  final bool showBackButton;
  final bool showCrossButton;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final double height;
  final VoidCallback? onTapLeading;

  const CustomAppBar(
      {super.key,
        required this.title,
        this.actionIcon,
        this.showBackButton = false,
        this.showCrossButton = false,
        this.leadingIcon,
        this.backgroundColor,
        this.height = kToolbarHeight + 10,
        this.onTapLeading
      });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      forceMaterialTransparency: true,
      centerTitle: true,
      toolbarHeight: height,
      title: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      actions: [actionIcon ?? const SizedBox()],
      leading: showBackButton
          ? IconButton(
              onPressed: onTapLeading ?? () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(

                    shape: BoxShape.circle),
                child: Icon(
                  showCrossButton ? Icons.close : Icons.adaptive.arrow_back,
                  size: 25,
                ),
              ))
          : Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        AppImages.logo,
                      ),
                      fit: BoxFit.contain),
                  shape: BoxShape.circle),
            ),
      leadingWidth: showBackButton ? 50 : 80,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
