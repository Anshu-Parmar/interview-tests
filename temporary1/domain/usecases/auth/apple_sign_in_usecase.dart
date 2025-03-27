import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class AppleSignInUsecase {
  final AuthRepository repository;

  AppleSignInUsecase({required this.repository});

  Future<String> call() async {
    return repository.appleSignIn();
  }
}