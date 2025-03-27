import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:startopreneur/data/sources/auth/firebase_services.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/repository/auth/auth_repository.dart';
import 'package:startopreneur/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  AuthRepositoryImpl({
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<UserEntity> getUser() async {
    return await sl<FirebaseService>().getUser();
  }

  @override
  Future<String> signIn(UserEntity signInUser) async {
    return await sl<FirebaseService>().signIn(signInUser);
  }

  @override
  Future<String> signup(UserEntity user) async {
    return await sl<FirebaseService>().signup(user);
  }

  @override
  Future<bool> isSignedIn() async {
    return await sl<FirebaseService>().isSignedIn();
  }

  @override
  Future<void> signOut() async {
    return await sl<FirebaseService>().signOut();
  }

  @override
  Future<String> getCurrentUserUid() async {
    return await sl<FirebaseService>().getCurrentUserUid();
  }

  @override
  Future<String> sendForgotPasswordEmail(String email) async {
    return await sl<FirebaseService>().sendForgotPasswordEmail(email);
  }

  @override
  Future<String> updateUserData(UserEntity user) async {
    return await sl<FirebaseService>().updateUserData(user);
  }

  @override
  Future<String> deleteAllUserData(UserEntity user) async {
    return await sl<FirebaseService>().deleteAllUserData(user);
  }

  @override
  Future<String> googleSignIn() async {
    return await sl<FirebaseService>().googleSignIn();
  }

  @override
  Future<String> appleSignIn() async {
    return await sl<FirebaseService>().appleSignIn();
  }

  @override
  Future<List<String>> getUserProvider() async {
    return await sl<FirebaseService>().getUserProvider();
  }
}