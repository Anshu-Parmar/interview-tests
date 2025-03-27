import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/profile/pages/guest_profile_page.dart';
import 'package:startopreneur/presentation/profile/pages/profile_page.dart';

class LandingPageProfile extends StatelessWidget {
  const LandingPageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // print("NEW STATE : ${state.toString()}");
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const ProfilePage();
          }

          if (state is Unauthenticated) {
            return const GuestProfilePage();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
