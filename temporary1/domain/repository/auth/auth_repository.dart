import 'package:startopreneur/domain/entities/auth/user.dart';

abstract class AuthRepository {

  Future<String> signup(UserEntity user);

  Future<String> signIn(UserEntity signInUser);

  Future<String> googleSignIn();

  Future<String> appleSignIn();

  Future<UserEntity> getUser();

  Future<bool> isSignedIn();

  Future<void> signOut();

  Future<String> getCurrentUserUid();

  Future<String> sendForgotPasswordEmail(String email);

  Future<String> updateUserData(UserEntity user);

  Future<String> deleteAllUserData(UserEntity user);

  Future<List<String>> getUserProvider();
}