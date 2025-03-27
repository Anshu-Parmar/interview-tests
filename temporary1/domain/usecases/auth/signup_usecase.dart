import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class SignUpUseCase{
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<String> call(UserEntity user){
    return repository.signup(user);
  }
}