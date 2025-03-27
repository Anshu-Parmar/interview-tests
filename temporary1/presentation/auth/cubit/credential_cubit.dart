import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/domain/usecases/auth/apple_sign_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/send_forgot_password_email_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/signin_user_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/signup_usecase.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/cubit/add_or_remove_bookmark/add_or_remove_bookmark_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/presentation/home/pages/home_page.dart';
import 'package:startopreneur/service_locator.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  CredentialCubit() : super(CredentialInitial());

  Future<void> forgotPassword({required String email, required BuildContext context}) async {
    emit(CredentialLoading());
    try {
      await sl<SendForgotPasswordEmailUsecase>().call(email).then((result) {
        if (result != 'success') {
          if (result.contains("user-not-found") && context.mounted) {
            SnackBarDisplay(
              context: context,
              message: ErrorMessages.userNotFound,
            ).showSnackBar();
          }
        } else {
          if(context.mounted) {
            SnackBarDisplay(
              context: context,
              message: ValidationMessages.sentEmailSuccess,
            ).showSnackBar();
          }
          emit(CredentialLoaded());
        }
      });
    } on SocketException catch (e) {
      emit(CredentialFailure(message: e.message));
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }

  Future<void> signInSubmit(
      {required String email,
      required String password,
      required BuildContext context,
      BookMarkItem? bookMarkItem,
      int? tabIndex}) async {
    emit(CredentialLoading());

    try {
      var result = await sl<SignInUseCase>().call(UserEntity(email: email, password: password));
      if (result != 'success') {
        if (result.contains("wrong-password") && context.mounted) {
          SnackBarDisplay(
            context: context,
            message: ErrorMessages.wrongPassword,
          ).showSnackBar();
        } else {
          if(context.mounted) {
            SnackBarDisplay(
              context: context,
              message: result,
            ).showSnackBar();
          }
        }
        emit(CredentialLoaded());
      } else {
        if(context.mounted) _loadAllData(context, bookMarkItem: bookMarkItem, tabIndex: tabIndex);
      }
    } on SocketException catch (e) {
      emit(CredentialFailure(message: e.message));
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }

  Future<void> signUpSubmit(
      {required UserEntity user, required BuildContext context, BookMarkItem? bookMarkItem, int? tabIndex}) async {
    emit(CredentialLoading());
    try {
      String result = await sl<SignUpUseCase>().call(UserEntity(name: user.name, email: user.email, password: user.password));
      if (result != 'success' && context.mounted) {
        SnackBarDisplay(
          context: context,
          message: result,
        ).showSnackBar();
        emit(CredentialLoaded());
      } else {
        if(context.mounted) _loadAllData(context, bookMarkItem: bookMarkItem, tabIndex: tabIndex);
      }
    } on SocketException catch (e) {
      emit(CredentialFailure(message: e.message));
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }

  Future<void> googleSignInSubmit({required BuildContext context, BookMarkItem? bookMarkItem, int? tabIndex}) async {
    emit(CredentialLoading());
    try {
      String result = await sl<GoogleSignInUsecase>().call();
      if (result != 'success') {
        if(result == 'none-chosen') {
          //USER BACKED OUT OF GOOGLE PROMPT
        } else {
          if(context.mounted) {
            SnackBarDisplay(
              context: context,
              message: result,
              time: 2500,
            ).showSnackBar();
          }
        }
        emit(CredentialLoaded());
      } else {
        if(context.mounted)  _loadAllData(context, bookMarkItem: bookMarkItem, tabIndex: tabIndex);
      }
    } on SocketException catch (e) {
      emit(CredentialFailure(message: e.message));
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }

  Future<void> appleSignInSubmit({required BuildContext context, BookMarkItem? bookMarkItem, int? tabIndex}) async {
    emit(CredentialLoading());
    try {
      String result = await sl<AppleSignInUsecase>().call();
      if (result != "success") {
        if(result == 'none-chosen') {
          //USER BACKED OUT OF APPLE PROMPT
        } else if (result != 'success') {
          if(context.mounted) {
            SnackBarDisplay(
              context: context,
              message: result,
              time: 2500,
            ).showSnackBar();
          }
        }
        emit(CredentialLoaded());
      } else {
        if(context.mounted) _loadAllData(context, bookMarkItem: bookMarkItem, tabIndex: tabIndex);
      }
    } on SocketException catch (e) {
      emit(CredentialFailure(message: e.message));
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }

  Future<void> _loadAllData(BuildContext context, {BookMarkItem? bookMarkItem, int? tabIndex}) async {
    try {
      await context.read<AuthCubit>().loggedIn();
      if (bookMarkItem != null) {
        await CubitManager().getCubit(bookMarkItem.title!).toggleBookMark(bookMarkItem);
      }
      if (tabIndex != null) {
        Future.delayed(Duration(seconds: 1), () => tabController.index = tabIndex,);
      }
      if(context.mounted) {
        context.read<AllNewsCubit>().loadAllNews();
        Navigator.popUntil(context, (route) => route.settings.name == null && route.isFirst,);
      }
    } catch (e) {
      log("LOAD ALL DATA ERROR - ${e.toString()}", name: 'CRED-CUBIT');
    }
  }
}
