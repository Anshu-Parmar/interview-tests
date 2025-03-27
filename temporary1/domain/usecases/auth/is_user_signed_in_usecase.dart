import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class IsSignInUseCase {
  final AuthRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call()async{
    return repository.isSignedIn();
  }
}