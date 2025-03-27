import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeColorCubit extends Cubit<bool> {
  ChangeColorCubit() : super(false);

  void change(int index) {
    emit(!state);
  }
}