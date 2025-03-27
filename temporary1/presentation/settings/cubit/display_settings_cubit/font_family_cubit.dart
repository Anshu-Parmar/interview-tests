// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:startopreneur/core/source/shared_preferences_services.dart';
//
// class FontFamilyCubit extends Cubit<String?> {
//   FontFamilyCubit() : super('Mulish');
//
//   void getFonts() async {
//     final String value = await SharedPreferencesService.getFontFamily() ?? 'Mulish';
//     emit(value);
//   }
//
//   void changeFontFamily (String value) async {
//     await SharedPreferencesService.saveFontFamily(value);
//     emit(value);
//   }
// }

//NO LONGER REQUIRED
// -- changes in following files
// 1. text_widget
// 3. main.dart