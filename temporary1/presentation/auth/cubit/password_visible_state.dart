part of 'password_visible_cubit.dart';

sealed class PasswordVisibleState {}

final class PasswordVisibilityInitial extends PasswordVisibleState {}

final class PasswordVisibilityUpdated extends PasswordVisibleState {
  final bool isVisible;
  PasswordVisibilityUpdated({required this.isVisible});
}

