import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class GetCurrentUserUidUsecase{
  final AuthRepository repository;

  GetCurrentUserUidUsecase({required this.repository});
  Future<String> call()async{
    return await repository.getCurrentUserUid();
  }
}