import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/common/widget/debouce/single_tap.dart';
import 'package:startopreneur/common/widget/rate_my_app/rate_app_init.dart';
import 'package:startopreneur/common/widget/text_field/custom_text_field.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/routes/edit_profile_arguments.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/core/source/project_enums.dart';
import 'package:startopreneur/presentation/auth/cubit/auth_cubit.dart';
import 'package:startopreneur/presentation/auth/cubit/password_visible_cubit.dart';
import 'package:startopreneur/presentation/home/cubit/all_news/all_news_cubit.dart';
import 'package:startopreneur/presentation/profile/cubit/current_user_cubit.dart';
import 'package:startopreneur/presentation/profile/widget/profile_container_widget.dart';
import 'package:startopreneur/presentation/settings/widget/about_us_widget.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final List<String> options = ['Display', 'About', 'Rate Start-O-Preneur', 'SignOut'];
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        return Scaffold(
            appBar: const CustomAppBar(
              title: 'Settings',
              showBackButton: true,
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 10, 16.0, 16.0),
                child: Column(
                  children: [
                    BlocBuilder<CurrentUserCubit, CurrentUserState>(
                      builder: (context, state) {
                        if (state is CurrentUserLoading) {
                          return ProfileContainerWidget(
                            user: null,
                          );
                        }

                        if (state is CurrentUserLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileContainerWidget(
                                user: state.currentUser,
                              ),
                              CustomElevatedButton(
                                  title: 'Edit Profile',
                                  transparentBackground: true,
                                  onPressed: () async =>
                                      context.read<AuthCubit>().getUserProvider().then((provider) {
                                        Navigator.pushNamed(
                                            context,
                                            RouteNames.editProfilePage,
                                            arguments: EditProfileArguments(
                                                state.currentUser,
                                                provider
                                            )
                                        );
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             EditProfilePage(
                                        //               user: state.currentUser,
                                        //               provider: provider,
                                        //             )));
                                      })),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomElevatedButton(
                                  title: 'Delete Account',
                                  borderColor: Colors.red,
                                  transparentBackground: true,
                                  onPressed: () async {
                                    final provider = await context.read<AuthCubit>().getUserProvider();
                                    _showDeleteDialog(context, providers: provider);
                                  }),
                            ],
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Navigator.pushNamed(context, RouteNames.displaySetting);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => DisplaySettingsPage(),
                                    //     ));
                                  case 1:
                                    CustomAboutUsModalSheet.showModelBottomSheet(context);
                                  case 2:
                                    RateAppInitWidget.showReviewDialog(context);
                                  case 3:
                                    _showSignOutDialog(context);
                                }
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  options[index],
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, fontFamily: 'Mulish'),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  grade: 3,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                )));
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Do you want to signout ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
              child: const Text(
                'SignOut',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
              ),
              onPressed: () async {
                _showLoaderDialog(context);
                context.read<AuthCubit>().loggedOut();
                // BlocProvider.of<UserBookmarksCubit>(context).loadBookmarkTitles(context);
                await context.read<CurrentUserCubit>().getCurrentUserProfile();
                context.read<AllNewsCubit>().loadAllNews();

                Navigator.popUntil(context, (route) => route.settings.name == null && route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext mainContext, {required List<String> providers}) {
    SingleTapDetector.isClicked = false;
    showDialog<void>(
      context: mainContext,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (context.mounted) {
                _passwordController.clear();
              }
            },
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Colors.transparent,
                  ),
                ),
                AlertDialog(
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  backgroundColor: context.isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(color: Colors.red, height: 1.3),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'If you select DELETE we will delete your account on our server. '
                                  'Your app data will also be deleted and you won\'t be able to retrieve it. '
                                  'This is a security-sensitive operation! ',
                            ),
                            if(providers.contains(Providers.password.name)) ... [
                              TextSpan(
                                text: 'Please enter your password before your account can be deleted.',
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (providers.contains(Providers.password.name)) ...[
                        const Text(
                          'Enter Password',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocProvider<PasswordVisibleCubit>(
                          create: (context) => PasswordVisibleCubit(),
                          child: BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hintText: 'Password',
                                  keyBoardType: TextInputType.visiblePassword,
                                  obscureText: state is PasswordVisibilityUpdated ? state.isVisible : true,
                                  textEditingController: _passwordController,
                                  removePrefixSpace: true,
                                  showBorder: false,
                                  trailingIcon: state is PasswordVisibilityUpdated
                                      ? InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(!state.isVisible);
                                      },
                                      child: SvgPicture.asset(
                                        state.isVisible ? AppVectors.notVisible : AppVectors.visible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn),
                                      ))
                                      : InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(false);
                                      },
                                      child: SvgPicture.asset(
                                        AppVectors.notVisible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn),
                                      )));
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor),
                      ),
                      onPressed: () {
                        _passwordController.clear();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.all(5)),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),
                      onPressed: () {
                        final password = _passwordController.text.trim();
                        if (SingleTapDetector.isClicked == false) {
                          SingleTapDetector.startTimer();
                          SingleTapDetector.isClicked = true;

                          if (providers.contains(Providers.password.name)) {
                            if (_passwordController.text.isEmpty) {
                              SnackBarDisplay(
                                context: context,
                                message: ValidationMessages.enterPassword,
                              ).showSnackBar();
                            } else {
                              _showLoaderDialog(context);
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<AuthCubit>().deleteCurrentUser(context, password: password);
                            }
                          } else {
                            _showLoaderDialog(context);
                            context.read<AuthCubit>().deleteCurrentUser(context);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      insetPadding: EdgeInsets.all(20.0),
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 10),
          const Text("Loading..."),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(canPop: false, child: alert);
      },
    );
  }
}

