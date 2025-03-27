import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/usecases/auth/delete_all_user_data_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/get_current_user_uid_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/get_user_provider_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/is_user_signed_in_usecase.dart';
import 'package:startopreneur/domain/usecases/auth/sign_out_usecase.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> appStarted() async {
    try{
      final isSignIn = await sl<IsSignInUseCase>().call();

      if(isSignIn) {
        final uid = await sl<GetCurrentUserUidUsecase>().call();
        emit(Authenticated(uid: uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await sl<GetCurrentUserUidUsecase>().call();
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> loggedOut() async {
    try{
      await sl<SignOutUseCase>().call();
      emit(Unauthenticated());
    }catch (_) {
      final uid = await sl<GetCurrentUserUidUsecase>().call();
      emit(Authenticated(uid: uid));
    }
  }

  Future<void> deleteCurrentUser(BuildContext context, {String? password}) async {
    try{
      final result = await sl<DeleteAllUserDataUsecase>().call(UserEntity(password: password));

      if(result == "success") {
        // context.read<UserBookmarksCubit>().loadBookmarkTitles(context);
        // context.read<CurrentUserCubit>().getCurrentUserProfile();
        context.read<AllNewsCubit>().loadAllNews();
        context.read<AuthCubit>().loggedOut();
        Navigator.popUntil(context, (route) => route.settings.name == null && route.isFirst,);
        emit(Unauthenticated());
      } else {
        if(context.mounted) {
          Navigator.pop(context);
        }
        if (result.contains("wrong-credentials")) {
          SnackBarDisplay(
            context: context,
            message: ErrorMessages.credentialValidity,
          ).showSnackBar();
        } else if (result.contains("wrong-password")) {
          SnackBarDisplay(
            context: context,
            message: ErrorMessages.wrongPassword,
          ).showSnackBar();
        } else if (result.contains("network-request-failed")) {
          SnackBarDisplay(
            context: context,
            message: ErrorMessages.networkError,
          ).showSnackBar();
        } else if (result.contains("many-request")) {
          SnackBarDisplay(
            context: context,
            message: "Please try again after some time!",
          ).showSnackBar();
        } else {
          SnackBarDisplay(
            context: context,
            message: result,
          ).showSnackBar();
        }
      }
    } catch (_) {
      final uid = await sl<GetCurrentUserUidUsecase>().call();
      emit(Authenticated(uid: uid));
    }
  }

  Future<List<String>> getUserProvider () async {
    try{
      final List<String> provider = await sl<GetUserProviderUsecase>().call();
      return provider;
    }catch (_) {
      final uid = await sl<GetCurrentUserUidUsecase>().call();
      emit(Authenticated(uid: uid));
      return [];
    }
  }
}