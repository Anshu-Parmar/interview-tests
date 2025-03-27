part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class Authenticated extends AuthState {
  final String uid;

  Authenticated({required this.uid});
}

final class Unauthenticated extends AuthState {}

