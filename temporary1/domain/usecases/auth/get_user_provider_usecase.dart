import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class GetUserProviderUsecase{
  final AuthRepository repository;

  GetUserProviderUsecase({required this.repository});

  Future<List<String>> call(){
    return repository.getUserProvider();
  }
}