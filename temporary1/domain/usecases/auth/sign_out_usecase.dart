import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class SignOutUseCase{
  final AuthRepository repository;
  SignOutUseCase({required this.repository});

  Future<void> call(){
    return repository.signOut();
  }
}