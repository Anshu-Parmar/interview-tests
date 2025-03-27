import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' as service;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:startopreneur/core/configs/constants/global_constants.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/source/project_enums.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';

abstract class FirebaseService {
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

class FirebaseServiceImpl extends FirebaseService {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignInInstance;
  AppleAuthProvider appleProvider;

  FirebaseServiceImpl({
    required this.fireStore,
    required this.auth,
    required this.googleSignInInstance,
    required this.appleProvider,
  });

  @override
  Future<String> signIn(UserEntity signInUser) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signInUser.email!,
          password: signInUser.password!
      );

      return "success";
    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'invalid-email') {
        message = ErrorMessages.invalidEmail;
      } else if (e.code == 'invalid-credential') {
        message = ErrorMessages.wrongPassword;
      } else if (e.code == 'user-not-found') {
        message = ErrorMessages.userNotFound;
      } else {
        log("${e.code}:${e.message}", name: "AUTH");
        message = e.code;
      }

      return message;
    }
  }

  @override
  Future<String> signup(UserEntity user) async {
    UserCredential? dataCredential;
    try {
      dataCredential = await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      await fireStore
          .collection(Collections.users.collectionName)
          .doc(dataCredential.user?.uid)
          .set({
        'name': user.name,
        'email': dataCredential.user?.email,
        'createdAt': Timestamp.now(),
        'createdBy': user.name
      });
      await auth.currentUser?.updateDisplayName(user.name);

      return "success";
    } on FirebaseAuthException catch (e) {
      String message = "";

      if (e.code == 'weak-password') {
        message = ValidationMessages.enterValidPassword;
      } else if (e.code == 'email-already-in-use') {
        message = ErrorMessages.emailExists;
      } else {
        log("${e.code}:${e.message}", name: "AUTH");
      }
      return message;
    }
  }

  @override
  Future<UserEntity> getUser() async {
    final uid = await getCurrentUserUid();

    try {
      final doc = await fireStore.collection('Users').doc(uid).get();
      var email = auth.currentUser?.email;
      var name = auth.currentUser?.displayName;

      if (doc.data()?['email'] != email) {
        await fireStore.collection('Users').doc(uid).update({'email': email});
      }

      if (email == null || name == null) {
        await fireStore.collection('Users').doc(uid).get().then((doc) {
          name = doc.data()?['name'];
          email = doc.data()?['email'];
        });
      }

      return UserEntity(
        name: name,
        email: email
      );
    } catch (e) {
      log("$e", name: "AUTH/USER");
      return UserEntity();
    }
  }

  @override
  Future<bool> isSignedIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signOut() async {
    await googleSignInInstance.signOut();
    await auth.signOut();
  }

  @override
  Future<String> getCurrentUserUid() async => auth.currentUser!.uid;

  @override
  Future<String> sendForgotPasswordEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
        ///REQUIRE TO ACTIVATE DYNAMIC LINKING IN FIREBASE WHICH IS DEPRECATED
        // actionCodeSettings: acs
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      log("${e.code}:${e.message}", name: "AUTH/PASSWORD");
      return e.code;
    }
  }

  @override
  Future<String> updateUserData(UserEntity user) async {
    final uid = await getCurrentUserUid();
    final currentUserEmail = auth.currentUser?.email;
    bool updateEmail = false;
    bool updatePassword = false;
    Map<String, dynamic> userInformation = {};
    String message = "success";

    try {
      if (user.name != null) {
        userInformation['name'] = user.name;
      }
      if (user.email != null) {
        updateEmail = true;
      }
      if (user.password != null && user.oldPassword != null) {
        updatePassword = true;
      }

      if (updateEmail || updatePassword || userInformation.isNotEmpty) {
        await fireStore.runTransaction((transaction) async {
          final document = fireStore.collection('Users').doc(uid);
          userInformation['updatedAt'] = Timestamp.now();

          if (updatePassword
              // || updateEmail
              ) {
            var credential = EmailAuthProvider.credential(
              email: currentUserEmail!,
              password: user.oldPassword!,
            );

            await auth.currentUser?.reauthenticateWithCredential(credential);
          }

          if (updatePassword) {
            await auth.currentUser?.updatePassword(user.password!);
          }
          if (updateEmail) {
            await auth.currentUser?.verifyBeforeUpdateEmail(user.email!);
            message = "update";
          }
          if (userInformation.isNotEmpty) {
            transaction.update(document, userInformation);
            if (userInformation.containsKey('name')) {
              await auth.currentUser?.updateDisplayName(userInformation['name']);
              message = "update";
            }
          }
        });
      }
      return message;
    } on FirebaseException catch (e) {
      log("${e.code}:${e.message}", name: "AUTH/UPDATE");
      return e.toString();
    } catch (e) {
      log("$e", name: "AUTH/UPDATE");
      return e.toString();
    }
  }

  @override
  Future<String> deleteAllUserData(UserEntity user) async {
    final uid = await getCurrentUserUid();
    final provider = await getUserProvider();
    final currentUserEmail = auth.currentUser?.email;
    WriteBatch writeBatch = fireStore.batch();
    final userDocument = fireStore
        .collection('Users')
        .doc(uid);
    final bookMarkDocuments = await fireStore
        .collection(Collections.bookmark.collectionName)
        .where('uid', isEqualTo: uid)
        .where('isBookMarked', isEqualTo: true)
        .get();
    final channelDocuments = await fireStore
        .collection(Collections.followed.collectionName)
        .where('userId', isEqualTo: uid)
        .get();
    final defaultUnfollowedChannelDocs = await fireStore
        .collection(Collections.unfollowed.collectionName)
        .where('userId', isEqualTo: uid)
        .get();

    if (provider.contains(Providers.password.name) && user.password != null) {
      try {
        var credential = EmailAuthProvider.credential(
          email: currentUserEmail!,
          password: user.password!,
        );

        UserCredential? userCredential = await auth.currentUser?.reauthenticateWithCredential(credential);

        if (userCredential != null) {
          await userCredential.user?.delete();
          writeBatch.delete(userDocument);
          for (var docRef in bookMarkDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in channelDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in defaultUnfollowedChannelDocs.docs) {
            writeBatch.delete(docRef.reference);
          }
          await writeBatch.commit();
          await signOut();
          return "success";
        } else {
          return "wrong-credentials";
        }
      } on FirebaseAuthException catch (e) {
        log("${e.code}:${e.message}", name: "AUTH/PASSWORD");
        return "${e.message}";
      } catch (e) {
        log("$e", name: "AUTH/PASSWORD");
        return "$e";
      }
    } else if (provider.contains(Providers.google.name) && provider.contains(Providers.currentGoogle.name)) {
      try {
        final GoogleSignInAccount? gUser = googleSignInInstance.currentUser;
        UserCredential? userCredential;
        if (gUser != null) {
          final GoogleSignInAuthentication gAuth = await gUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken,
            idToken: gAuth.idToken,
          );
          userCredential = await auth.currentUser?.reauthenticateWithCredential(credential);
        }

        if (userCredential != null) {
          await userCredential.user?.delete();
          writeBatch.delete(userDocument);
          for (var docRef in bookMarkDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in channelDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in defaultUnfollowedChannelDocs.docs) {
            writeBatch.delete(docRef.reference);
          }
          await writeBatch.commit();
          await googleSignInInstance.disconnect();
          await googleSignInInstance.signOut();
          await signOut();
          return "success";
        } else {
          return "wrong-google-credential";
        }
      } on FirebaseAuthException catch (e) {
        log("${e.code}:${e.message}", name: "AUTH/GOOGLE");
        return "${e.message}";
      } catch (e) {
        log("$e", name: "AUTH/GOOGLE");
        return "$e";
      }
    } else if (provider.contains(Providers.apple.name) && provider.contains(Providers.currentApple.name)) {
      try {
        final UserCredential? userCredential = await auth.currentUser?.reauthenticateWithProvider(appleProvider);

        if (userCredential != null) {
          if (targetPlatform == service.TargetPlatform.iOS) {
            var authCode = userCredential.additionalUserInfo?.authorizationCode;
            await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);
          }
          await auth.currentUser?.delete();
          writeBatch.delete(userDocument);
          for (var docRef in bookMarkDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in channelDocuments.docs) {
            writeBatch.delete(docRef.reference);
          }
          for (var docRef in defaultUnfollowedChannelDocs.docs) {
            writeBatch.delete(docRef.reference);
          }
          await writeBatch.commit();
          await signOut();
          return "success";
        } else {
          return "wrong-apple-credential";
        }
      } on FirebaseAuthException catch (e) {
        log("${e.code}:${e.message}", name: "AUTH/APPLE");
        return "${e.message}";
      } catch (e) {
        log("$e", name: "AUTH/APPLE");
        return "$e";
      }
    } else {
      return "wrong-credentials";
    }
  }

  @override
  Future<String> googleSignIn() async {
    try {
      final GoogleSignInAccount? gUser = await googleSignInInstance.signIn();

      if (gUser != null) {
        String? name = gUser.displayName;

        final GoogleSignInAuthentication gAuth = await gUser.authentication.whenComplete(() {
          gUser.clearAuthCache();
        });
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        final UserCredential userCredential = await auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await fireStore
                .collection(Collections.users.collectionName)
                .doc(userCredential.user?.uid)
                .set({'name': name, 'email': userCredential.user?.email, 'createdAt': Timestamp.now(), 'createdBy': name});
          }
        }
        await auth.currentUser?.updateDisplayName(name);

        return "success";
      } else {
        return "none-chosen";
      }
    } on FirebaseAuthException catch (e) {
      String message = e.code;

      if (e.code == 'invalid-credential') {
        message = ErrorMessages.wrongPassword;
      } else {
        log("${e.code}:${e.message}", name: 'AUTH/GOOGLE');
        message = e.code;
      }

      return message;
    } catch (e) {
      log("$e", name: 'AUTH/GOOGLE');
      return e.toString();
    }
  }

  @override
  Future<String> appleSignIn() async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithProvider(appleProvider);

      User? user = userCredential.user;

      if (user != null) {
        final reference = fireStore.collection(Collections.users.collectionName).doc(userCredential.user?.uid);
        final userDoc = await reference.get();
        final userData = userDoc.data();
        if (userCredential.additionalUserInfo!.isNewUser || userData == null) {
          reference.set({
            'name': user.providerData[0].displayName,
            'email': user.email,
            'createdAt': Timestamp.now(),
            'createdBy': user.providerData[0].displayName,
          });
          await auth.currentUser?.updateDisplayName(user.providerData[0].displayName);
        }
      }

      return "success";
    } on FirebaseAuthException catch (e) {
      String message = e.code;

      if (e.code == 'invalid-credential') {
        message = ErrorMessages.wrongPassword;
      } else {
        log("${e.code}:${e.message}", name: 'AUTH/APPLE');
        message = e.code;
      }

      return message;
    } catch (e) {
      String message = "$e";
      if (e.toString().contains("AuthorizationErrorCode.canceled")) {
        message = "none-chosen";
      }
      log("$e}", name: 'AUTH/APPLE');
      return message;
    }
  }

  @override
  Future<List<String>> getUserProvider() async {
    List<String> providers = [];
    if (auth.currentUser != null) {
      final providerData = auth.currentUser!.providerData;
      final idTokenResults = await auth.currentUser?.getIdTokenResult();

      for (var v in providerData) {
        providers.add(v.providerId);
      }

      if (idTokenResults != null) {
        final addition = idTokenResults.claims?['firebase']?['sign_in_provider'];
        if (addition == Providers.password.name) {
          providers.add(Providers.currentPassword.name);
        }
        if (addition == Providers.google.name) {
          providers.add(Providers.currentGoogle.name);
        }
        if (addition == Providers.apple.name) {
          providers.add(Providers.currentApple.name);
        }
      }
    }
    return providers;
  }
}
