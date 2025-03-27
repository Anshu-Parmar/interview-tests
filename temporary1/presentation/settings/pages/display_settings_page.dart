import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/core/configs/theme/cubit/theme_cubit.dart';
// import 'package:startopreneur/presentation/settings/cubit/display_settings_cubit/font_family_cubit.dart';
// import 'package:startopreneur/presentation/settings/cubit/display_settings_cubit/font_size_cubit.dart';
import 'package:startopreneur/presentation/settings/cubit/display_settings_cubit/theme_mode_cubit.dart';
import 'package:startopreneur/core/source/shared_preferences_services.dart';

class DisplaySettingsPage extends StatelessWidget {
  DisplaySettingsPage({super.key});

  // final List<String> _fontSizes = ['Small', 'Medium', 'Large', 'Extra Large', 'Jumbo'];

  final List<IconData> _themes = [CupertinoIcons.globe, Icons.dark_mode_outlined, Icons.light_mode_outlined];

  // final List<String> _fontStyles = ['Mulish', 'Poppins', 'Roboto'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>(
          create: (context) => ThemeModeCubit()..updateThemeMode(context.read<ThemesCubit>().themeModeSave),
        ),
      ],
      child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Display Settings',
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _fontChangeWidget(context),
                // const SizedBox(
                //   height: 20,
                // ),
                _themeChangeWidget(context),
                // _fontStyleChangeWidget(context)
              ],
            ),
          )),
    );
  }

  Widget _themeChangeWidget(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabWidget(
                    context: context,
                    onTap: () {
                      context.read<ThemeModeCubit>().updateThemeMode(ThemeMode.system);
                      context.read<ThemesCubit>().toggleTheme(AppThemeMode.system);
                    },
                    isSelected: state is ThemeModeSystem ? true : false,
                    icon: _themes[0],
                    name: 'System',
                  ),
                  _tabWidget(
                      context: context,
                      onTap: () {
                        context.read<ThemeModeCubit>().updateThemeMode(ThemeMode.dark);
                        context.read<ThemesCubit>().toggleTheme(AppThemeMode.dark);
                      },
                      isSelected: state is ThemeModeDark ? true : false,
                      icon: _themes[1],
                      name: 'Dark',
                      borderSideAll: false),
                  _tabWidget(
                    context: context,
                    onTap: () {
                      context.read<ThemeModeCubit>().updateThemeMode(ThemeMode.light);
                      context.read<ThemesCubit>().toggleTheme(AppThemeMode.light);
                    },
                    isSelected: state is ThemeModeLight ? true : false,
                    icon: _themes[2],
                    name: 'Light',
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  ///CODE COMMENTED OF TWO FUNCTIONALITIES: FONT-STYLE AND FONT-SIZE

  // Widget _fontChangeWidget(BuildContext context) {
  //   final pad = EdgeInsets.symmetric(horizontal: 16.0);
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: pad,
  //         child: Text(
  //           'Font Size',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 25,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: _fontSizes
  //             .map((label) => Expanded(
  //           child: Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               label,
  //               style: const TextStyle(fontSize: 10),
  //             ),
  //           ),
  //         ))
  //             .toList(),
  //       ),
  //       BlocBuilder<FontSizeCubit, double>(
  //         builder: (context, currentValue) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //             child: Slider(
  //               value: currentValue,
  //               min: 0,
  //               max: 5,
  //               divisions: 4,
  //               activeColor: AppColors.primaryColor,
  //               onChanged: (value) {
  //                 context.read<FontSizeCubit>().changeFontSize(value);
  //               },
  //             ),
  //           );
  //         },
  //       ),
  //       Padding(
  //         padding: pad,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "As",
  //               style: TextStyle(
  //                 fontSize: 16,
  //               ),
  //             ),
  //             Text(
  //               "As",
  //               style: TextStyle(
  //                 fontSize: 26,
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget _fontStyleChangeWidget(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: BlocBuilder<FontFamilyCubit, String?>(
  //       builder: (context, state) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Font Style',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 _tabWidget(
  //                   context: context,
  //                   onTap: () => context.read<FontFamilyCubit>().changeFontFamily(_fontStyles[0]),
  //                   isSelected: state == _fontStyles[0] ? true : false,
  //                   showIcon: false,
  //                   name: _fontStyles[0],
  //                 ),
  //                 _tabWidget(
  //                     context: context,
  //                     onTap: () => context.read<FontFamilyCubit>().changeFontFamily(_fontStyles[1]),
  //                     isSelected: state == _fontStyles[1] ? true : false,
  //                     showIcon: false,
  //                     name: _fontStyles[1],
  //                     borderSideAll: false),
  //                 _tabWidget(
  //                   context: context,
  //                   onTap: () => context.read<FontFamilyCubit>().changeFontFamily(_fontStyles[2]),
  //                   isSelected: state == _fontStyles[2] ? true : false,
  //                   showIcon: false,
  //                   name: _fontStyles[2],
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _tabWidget(
      {bool borderSideAll = true,
      IconData? icon,
      required String name,
      bool showIcon = true,
      required bool isSelected,
      required VoidCallback? onTap,
      required BuildContext context}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            border: borderSideAll
                ? Border.all(color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor)
                : Border.symmetric(
                    horizontal:
                        BorderSide(color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showIcon
                ? Icon(icon,
                    size: 15,
                    color: isSelected
                        ? context.isDarkMode
                            ? AppColors.darkBackgroundColor
                            : AppColors.lightBackgroundColor
                        : context.isDarkMode
                            ? AppColors.lightBackgroundColor
                            : AppColors.darkBackgroundColor)
                : const SizedBox(),
            SizedBox(
              width: showIcon ? 2 : 0,
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? context.isDarkMode
                          ? AppColors.darkBackgroundColor
                          : AppColors.lightBackgroundColor
                      : context.isDarkMode
                          ? AppColors.lightBackgroundColor
                          : AppColors.darkBackgroundColor),
            )
          ],
        ),
      ),
    ));
  }
}
