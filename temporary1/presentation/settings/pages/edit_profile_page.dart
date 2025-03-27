import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/helper/validation.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/text_field/custom_text_field.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/core/source/project_enums.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/presentation/auth/cubit/password_visible_cubit.dart';

import 'package:startopreneur/presentation/settings/cubit/update_profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;
  final List<String> provider;

  const EditProfilePage({super.key, required this.user, required this.provider});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? "Anonymous";
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///TO VERIFY PROVIDERS
    // print("PROVIDER/EDIT - ${widget.provider}");
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
        showCrossButton: true,
        actionIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: BlocProvider<UpdateProfileCubit>(
            create: (context) => UpdateProfileCubit(),
            child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
              builder: (context, state) {
                if (state is UpdateProfileLoading) {
                  return const CircularProgressIndicator();
                }
                return InkWell(
                  onTap: () async {
                    if (_nameController.text.isEmpty) {
                      SnackBarDisplay(
                        context: context,
                        message: ValidationMessages.enterName,
                      ).showSnackBar();
                    } else if (!_nameController.text.isValidName) {
                      SnackBarDisplay(
                        context: context,
                        message: ValidationMessages.enterValidName,
                      ).showSnackBar();
                    } else if (_passwordController.text.isNotEmpty &&
                        (_confirmPasswordController.text.isEmpty || _oldPasswordController.text.isEmpty)) {
                      if (_confirmPasswordController.text.isEmpty) {
                        SnackBarDisplay(
                          context: context,
                          message: ValidationMessages.enterConfirmPwd,
                        ).showSnackBar();
                      } else {
                        SnackBarDisplay(
                          context: context,
                          message: ValidationMessages.enterCurrentPwd,
                        ).showSnackBar();
                      }
                    } else if (_confirmPasswordController.text.isNotEmpty &&
                        (_passwordController.text.isEmpty || _oldPasswordController.text.isEmpty)) {
                      if (_passwordController.text.isEmpty) {
                        SnackBarDisplay(
                          context: context,
                          message: ValidationMessages.enterPassword,
                        ).showSnackBar();
                      } else {
                        SnackBarDisplay(
                          context: context,
                          message: ValidationMessages.enterCurrentPwd,
                        ).showSnackBar();
                      }
                    } else if (_passwordController.text.isNotEmpty && !_passwordController.text.isValidPassword) {
                      SnackBarDisplay(
                        context: context,
                        message: ValidationMessages.enterValidPassword,
                      ).showSnackBar();
                    } else if (_passwordController.text != _confirmPasswordController.text) {
                      SnackBarDisplay(
                        context: context,
                        message: ErrorMessages.passwordNoMatch,
                      ).showSnackBar();
                    } else {
                      final String? name = widget.user.name! != _nameController.text ? _nameController.text : null;
                      final String? password = _passwordController.text.isEmpty ? null : _passwordController.text;
                      final String? oldPassword = _oldPasswordController.text.isEmpty ? null : _oldPasswordController.text;

                      await BlocProvider.of<UpdateProfileCubit>(context).updateCurrentUserProfile(
                        context: context,
                        user: UserEntity(name: name, password: password, oldPassword: oldPassword),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.primaryColor),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: widget.user.name ?? "ERROR",
                        keyBoardType: TextInputType.name,
                        capitalize: true,
                        textEditingController: _nameController,
                        removePrefixSpace: true,
                        showBorder: false,
                      ),
                      const SizedBox(
                        height: 60,
                      ),

                      ///CHANGE EMAIL FUNCTIONALITY
                      // const Text(
                      //   'Email',
                      //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // CustomTextField(
                      //   hintText: widget.user.email ?? "ERROR",
                      //   keyBoardType: TextInputType.emailAddress,
                      //   textEditingController: _emailController,
                      //   removePrefixSpace: true,
                      //   showBorder: false,
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      if(widget.provider.contains(Providers.password.name)) ...[
                        const Text(
                          'Current Password',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocProvider<PasswordVisibleCubit>(
                          create: (context) => PasswordVisibleCubit(),
                          child: BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hintText: 'Current Password',
                                  keyBoardType: TextInputType.visiblePassword,
                                  obscureText: state is PasswordVisibilityUpdated ? state.isVisible : true,
                                  textEditingController: _oldPasswordController,
                                  removePrefixSpace: true,
                                  showBorder: false,
                                  trailingIcon: state is PasswordVisibilityUpdated
                                      ? InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(!state.isVisible);
                                      },
                                      child: SvgPicture.asset(
                                        state.isVisible ? AppVectors.notVisible :  AppVectors.visible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn
                                        ),
                                      )
                                  )
                                      : InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(false);
                                      },
                                      child: SvgPicture.asset(
                                        AppVectors.notVisible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn
                                        ),
                                      )
                                  )
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'New Password',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocProvider<PasswordVisibleCubit>(
                          create: (context) => PasswordVisibleCubit(),
                          child: BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hintText: 'New Password',
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
                                        state.isVisible ? AppVectors.notVisible :  AppVectors.visible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn
                                        ),
                                      )
                                  )
                                      : InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(false);
                                      },
                                      child: SvgPicture.asset(
                                        AppVectors.notVisible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn
                                        ),
                                      )
                                  )
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Confirm Password',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocProvider<PasswordVisibleCubit>(
                          create: (context) => PasswordVisibleCubit(),
                          child: BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hintText: 'Confirm Password',
                                  keyBoardType: TextInputType.visiblePassword,
                                  obscureText: state is PasswordVisibilityUpdated ? state.isVisible : true,
                                  inputActionLast: true,
                                  textEditingController: _confirmPasswordController,
                                  removePrefixSpace: true,
                                  showBorder: false,
                                  trailingIcon: state is PasswordVisibilityUpdated
                                      ? InkWell(
                                      onTap: () {
                                        context.read<PasswordVisibleCubit>().updateVisibility(!state.isVisible);
                                      },
                                      child: SvgPicture.asset(
                                        state.isVisible ? AppVectors.notVisible :  AppVectors.visible,
                                        fit: BoxFit.scaleDown,
                                        colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn),
                                      )
                                  )
                                      : InkWell(
                                    onTap: () {
                                      context.read<PasswordVisibleCubit>().updateVisibility(false);
                                    },
                                    child: SvgPicture.asset(
                                      AppVectors.notVisible,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn),
                                    ),
                                  ));
                            },
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
