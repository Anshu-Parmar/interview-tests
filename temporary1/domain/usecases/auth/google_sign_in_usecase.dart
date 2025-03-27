import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class GoogleSignInUsecase {
  final AuthRepository repository;

  GoogleSignInUsecase({required this.repository});

  Future<String> call() async {
    return repository.googleSignIn();
  }
}