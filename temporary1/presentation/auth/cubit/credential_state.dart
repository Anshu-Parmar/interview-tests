part of 'credential_cubit.dart';

sealed class CredentialState {}

final class CredentialInitial extends CredentialState {}

final class CredentialLoading extends CredentialState {}

final class CredentialLoaded extends CredentialState {}

final class CredentialFailure extends CredentialState {
  final String message;

  CredentialFailure({required this.message});
}
