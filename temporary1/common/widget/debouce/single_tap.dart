import 'dart:async';

class SingleTapDetector {
  static var isClicked = false;
  static late Timer timer;

  static startTimer({int time = 2500}) {
    timer = Timer(Duration(milliseconds: time), () => isClicked = false);
  }
}