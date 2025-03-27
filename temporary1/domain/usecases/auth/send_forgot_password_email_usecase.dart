import 'package:startopreneur/domain/repository/auth/auth_repository.dart';

class SendForgotPasswordEmailUsecase {
  final AuthRepository repository;

  SendForgotPasswordEmailUsecase({required this.repository});

  Future<String> call(String email) async {
    return await repository.sendForgotPasswordEmail(email);
  }
}