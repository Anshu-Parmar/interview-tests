import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/usecases/auth/update_user_data_usecase.dart';
import 'package:startopreneur/presentation/profile/cubit/current_user_cubit.dart';
import 'package:startopreneur/service_locator.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileLoaded());

  Future<void> updateCurrentUserProfile({required BuildContext context, required UserEntity user}) async {
    emit(UpdateProfileLoading());
    try {
      final result = await sl<UpdateUserDataUsecase>().call(user);
      if (result != "success" && result != "update") {
        if (result.contains("wrong-password")) {
          SnackBarDisplay(
            context: context,
            message: ErrorMessages.wrongPassword,
          ).showSnackBar();
        } else {
          SnackBarDisplay(
            context: context,
            message: result,
          ).showSnackBar();
        }
        emit(UpdateProfileLoaded());
      } else {
        if (result == "update") {
          BlocProvider.of<CurrentUserCubit>(context).getCurrentUserProfile();
        }
        SnackBarDisplay(
          context: context,
          message: "Profile updated!",
        ).showSnackBar();
        Navigator.pop(context);
      }
    } on SocketException catch (e) {
      emit(UpdateProfileFailure(message: e.toString()));
    } catch (e) {
      emit(UpdateProfileFailure(message: e.toString()));
    }
  }
}
