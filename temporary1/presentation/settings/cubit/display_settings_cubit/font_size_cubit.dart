// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:startopreneur/core/source/shared_preferences_services.dart';
//
// class FontSizeCubit extends Cubit<double> {
//   FontSizeCubit() : super(0);
//
//   void getFonts() async {
//     final int value = await SharedPreferencesService.getFontSize() ?? 1;
//     emit(value.roundToDouble());
//   }
//
//   double assignTextSize() {
//     double size = 14;
//     switch (state) {
//       case 0.0:
//         size = 14;
//         break;
//       case 1.0:
//         size = 16;
//         break;
//       case 3.0:
//         size = 18;
//         break;
//       case 4.0:
//         size = 20;
//         break;
//       case 5.0:
//         size = 22;
//         break;
//     }
//     return size;
//   }
//
//   void changeFontSize (double value) async {
//     ///FOR DEBUGGING AND UPDATING FONT SIZE CHECK THIS
//     // print(value.roundToDouble().toInt());
//     await SharedPreferencesService.saveFontSize(value.roundToDouble().toInt());
//     emit(value.roundToDouble());
//   }
// }

//NO LONGER REQUIRED
// -- changes in following files
// 1. text_widget
// 2. news_banner_widget
// 3. main.dart
