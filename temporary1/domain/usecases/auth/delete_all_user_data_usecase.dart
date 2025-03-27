import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class DeleteAllUserDataUsecase{
  final AuthRepository repository;

  DeleteAllUserDataUsecase({required this.repository});

  Future<String> call(UserEntity user){
    return repository.deleteAllUserData(user);
  }
}