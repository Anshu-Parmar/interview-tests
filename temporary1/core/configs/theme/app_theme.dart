import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/core/configs/theme/custom/custom_slider_theme_data.dart';
import 'package:startopreneur/core/configs/theme/custom/custom_tick_mark.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.lightBackgroundColor,
      fontFamily: 'Mulish',
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          //UPDATED AS THE STATUS BAR ICONS IS NOT VISIBLE IN IOS DEVICES
          statusBarIconBrightness: Brightness.dark, //FOR ANDROID STATUS BAR
          statusBarBrightness: Brightness.light, //FOR IOS STATUS BAR
          statusBarColor: Colors.transparent,
          // statusBarBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: true,
          systemNavigationBarColor: AppColors.lightBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.light
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.darkBackgroundColor
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBackgroundColor,
        hintStyle: const TextStyle(
          color: AppColors.hintTextColor,
        ),
        contentPadding: const EdgeInsets.all(12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 0.6
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
                color: AppColors.hintTextColor,
                width: 0.6
            ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
                color: AppColors.hintTextColor,
                width: 0.6
            )
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: AppColors.primaryColor)
              )
          )
      ),
    dividerTheme: const DividerThemeData(
      color: AppColors.neutralOffWhiteColor,
      thickness: 2,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.darkBackgroundColor,
      selectionColor: AppColors.primaryColor,
      selectionHandleColor: AppColors.darkBackgroundColor,
    ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
        circularTrackColor: AppColors.neutralOffWhiteColor,
      ),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      labelColor: AppColors.primaryColor,
      labelPadding: EdgeInsets.symmetric(horizontal:20),
      unselectedLabelColor: AppColors.darkBackgroundColor,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: AppColors.primaryColor,
                width: 5
            )
        ),
        color:AppColors.lightBackgroundColor,
      ),
    ),
    sliderTheme: SliderThemeData(
      trackShape: CustomSliderTrackShape(),
      thumbShape: CustomSliderThumbShape(),
      overlayShape: CustomSliderOverlayShape(),
      valueIndicatorColor: AppColors.primaryColor,
      tickMarkShape: CustomTickMarkShape(),
      activeTickMarkColor: AppColors.primaryColor,
      activeTrackColor: AppColors.primaryColor,
      inactiveTickMarkColor: Colors.red,
      inactiveTrackColor: AppColors.darkBackgroundColor,
      trackHeight: 1,
    ),
    dialogBackgroundColor: AppColors.lightBackgroundColor,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightBackgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      contentTextStyle: TextStyle(
        fontFamily: "Roboto",
        color: AppColors.lightBackgroundColor
      ),
      actionBackgroundColor: AppColors.darkBackgroundColor,
      actionTextColor: AppColors.lightBackgroundColor
    ),
  );


  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    fontFamily: 'Mulish',
    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        //UPDATED AS THE STATUS BAR ICONS IS NOT VISIBLE IN IOS DEVICES
        statusBarIconBrightness: Brightness.light, //FOR ANDROID STATUS BAR
        statusBarBrightness: Brightness.dark, //FOR IOS STATUS BAR
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: true,
        // statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark
      ),
    ),
    textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: AppColors.lightBackgroundColor
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBackgroundColor,
      hintStyle: const TextStyle(
        color: AppColors.neutralOffWhiteColor,
      ),
      contentPadding: const EdgeInsets.all(12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 0.6
        ),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
              color: AppColors.neutralOffWhiteColor,
              width: 0.4,
          )
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
              color: AppColors.neutralOffWhiteColor,
              width: 0.4
          )
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: AppColors.primaryColor)
            )
        )
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.neutralOffWhiteColor,
      thickness: 2,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.neutralOffWhiteColor,
      selectionColor: AppColors.primaryColor,
      selectionHandleColor: AppColors.lightBackgroundColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      circularTrackColor: AppColors.neutralOffWhiteColor,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      labelColor: AppColors.primaryColor,
      labelPadding: EdgeInsets.symmetric(horizontal: 20),
      unselectedLabelColor: AppColors.lightBackgroundColor,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: AppColors.primaryColor,
                width: 5
            )
        ),
        color:AppColors.darkBackgroundColor,
      ),
    ),
    sliderTheme: SliderThemeData(
      trackShape: CustomSliderTrackShape(),
      thumbShape: CustomSliderThumbShape(),
      overlayShape: CustomSliderOverlayShape(),
      valueIndicatorColor: AppColors.primaryColor,
      tickMarkShape: CustomTickMarkShape(),
      activeTickMarkColor: AppColors.primaryColor,
      activeTrackColor: AppColors.primaryColor,
      inactiveTickMarkColor: AppColors.darkBackgroundColor,
      inactiveTrackColor: AppColors.lightBackgroundColor,
      trackHeight: 1,
    ),
    dialogBackgroundColor: AppColors.darkBackgroundColor,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightBackgroundColor,
      contentTextStyle: TextStyle(
        fontFamily: "Roboto",
        color: AppColors.darkBackgroundColor,
      ),
      actionBackgroundColor: AppColors.lightBackgroundColor,
      actionTextColor: AppColors.darkBackgroundColor
    ),
  );

}