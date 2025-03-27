import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/usecases/auth/get_user_usecase.dart';
import 'package:startopreneur/service_locator.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {

  CurrentUserCubit() : super(CurrentUserLoading());

  Future<void> getCurrentUserProfile() async {
    emit(CurrentUserLoading());

    try{
      final response = await sl<GetUserUseCase>().call();
      emit(CurrentUserLoaded(currentUser:response));

    } on SocketException catch(e) {
      emit(CurrentUserFailure(message: e.toString()));
    } catch (e) {
      emit(CurrentUserFailure(message: e.toString()));
    }
  }

}
