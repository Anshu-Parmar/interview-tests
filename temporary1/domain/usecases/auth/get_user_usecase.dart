import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class GetUserUseCase{
  final AuthRepository repository;

  GetUserUseCase({required this.repository});

  Future<UserEntity> call() {
    return repository.getUser();
  }
}