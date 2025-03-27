import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class SignInUseCase{
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<String> call(UserEntity user){
    return repository.signIn(user);
  }
}