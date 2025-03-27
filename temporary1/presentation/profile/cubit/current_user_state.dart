part of 'current_user_cubit.dart';

sealed class CurrentUserState {}

final class CurrentUserLoading extends CurrentUserState {}

final class CurrentUserLoaded extends CurrentUserState {
  final UserEntity currentUser;
  CurrentUserLoaded({required this.currentUser});
}

final class CurrentUserFailure extends CurrentUserState {
  final String message;
  CurrentUserFailure({required this.message});
}
