import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/bookmarks/pages/bookmark_page.dart';
import 'package:startopreneur/presentation/bookmarks/pages/guest_bookmark_page.dart';

class LandingBookmarkPage extends StatelessWidget {
  const LandingBookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // print("NEW STATE : ${state.toString()}");
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const BookmarkPage();
          }

          if (state is Unauthenticated) {
            return const GuestBookmarkPage();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
