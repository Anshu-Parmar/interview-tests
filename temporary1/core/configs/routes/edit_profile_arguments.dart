import 'package:startopreneur/domain/entities/auth/user.dart';

class EditProfileArguments {
  final UserEntity user;
  final List<String> provider;

  EditProfileArguments(this.user, this.provider);
}