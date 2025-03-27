import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_visible_state.dart';

class PasswordVisibleCubit extends Cubit<PasswordVisibleState> {
  PasswordVisibleCubit() : super(PasswordVisibilityInitial());

  updateVisibility (bool value) {
    emit(PasswordVisibilityUpdated(isVisible: value));
  }
}