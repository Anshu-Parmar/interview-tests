part of 'update_profile_cubit.dart';

sealed class UpdateProfileState {}

final class UpdateProfileLoaded extends UpdateProfileState {}
final class UpdateProfileLoading extends UpdateProfileState {}
final class UpdateProfileFailure extends UpdateProfileState {
  final String message;
  UpdateProfileFailure({required this.message});
}
