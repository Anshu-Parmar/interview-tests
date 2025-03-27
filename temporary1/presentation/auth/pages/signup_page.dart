import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/helper/validation.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/common/widget/privacy_policy/privacy_policy_widget.dart';
import 'package:startopreneur/common/widget/text_field/custom_text_field.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/core/configs/routes/home_page_arguments.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/auth/user.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/presentation/auth/cubit/credential_cubit.dart';
import 'package:startopreneur/presentation/auth/cubit/password_visible_cubit.dart';

class SignupPage extends StatefulWidget {
  ///FOR BOOKMARK SAVING
  final int? tabIndex;
  final BookMarkItem? bookMarkItem;

  const SignupPage({super.key, this.bookMarkItem, this.tabIndex});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _againPasswordController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() => _scrollToFocusedNode(_focusNode1));
    _focusNode2.addListener(() => _scrollToFocusedNode(_focusNode2));
    _focusNode3.addListener(() => _scrollToFocusedNode(_focusNode3));
    _focusNode4.addListener(() => _scrollToFocusedNode(_focusNode4));
  }

  void _scrollToFocusedNode(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.pixels + 100,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _scrollController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _againPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showBackButton: true,
        backgroundColor: context.isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.logo))),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _textFields(context),
                      const SizedBox(
                        height: 30,
                      ),
                      BlocProvider(
                        create: (context) => CredentialCubit(),
                        child: BlocBuilder<CredentialCubit, CredentialState>(
                          builder: (context, state) {
                            if (state is CredentialLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomElevatedButton(
                                title: "Sign Up",
                                onPressed: () {
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
                                  } else if (_emailController.text.isEmpty) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ValidationMessages.enterEmail,
                                    ).showSnackBar();
                                  } else if (!_emailController.text.isValidEmail) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ValidationMessages.enterValidEmail,
                                    ).showSnackBar();
                                  } else if (_passwordController.text.isEmpty) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ValidationMessages.enterPassword,
                                    ).showSnackBar();
                                  } else if (!_passwordController.text.isValidPassword) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ValidationMessages.enterValidPassword,
                                    ).showSnackBar();
                                  } else if (_againPasswordController.text.isEmpty) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ValidationMessages.enterConfirmPwd,
                                    ).showSnackBar();
                                  } else if (_passwordController.text != _againPasswordController.text) {
                                    SnackBarDisplay(
                                      context: context,
                                      message: ErrorMessages.passwordNoMatch,
                                    ).showSnackBar();
                                  } else {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    BlocProvider.of<CredentialCubit>(context).signUpSubmit(
                                      user: UserEntity(
                                        name: _nameController.text.trim(),
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                      context: context,
                                      bookMarkItem: widget.bookMarkItem,
                                      tabIndex: widget.tabIndex
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Already have an account ? ',
                          style: const TextStyle(fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Log In',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(context, RouteNames.login, arguments: HomePageArguments(widget.bookMarkItem, widget.tabIndex)),

                                  )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                          heightFactor: 5,
                          child: PrivacyPolicyWidget(
                            height: 20,
                          )),
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

  _textFields(BuildContext context) {
    return Column(
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
          hintText: 'Enter Name',
          keyBoardType: TextInputType.name,
          capitalize: true,
          textEditingController: _nameController,
          focusNode: _focusNode1,
          autoFillHintsList: const [
            AutofillHints.name,
          ],
          prefixIcon: SvgPicture.asset(
            AppVectors.profile,
            fit: BoxFit.scaleDown,
            colorFilter: const ColorFilter.mode(AppColors.hintTextColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Email',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          hintText: 'Enter Email',
          enableSuggestions: true,
          keyBoardType: TextInputType.emailAddress,
          textEditingController: _emailController,
          focusNode: _focusNode2,
          prefixIcon: SvgPicture.asset(AppVectors.email, fit: BoxFit.scaleDown),
          autoFillHintsList: const [
            AutofillHints.email,
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Password',
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
                hintText: 'Enter Password',
                keyBoardType: TextInputType.visiblePassword,
                inputActionLast: false,
                obscureText: state is PasswordVisibilityUpdated ? state.isVisible : true,
                textEditingController: _passwordController,
                focusNode: _focusNode3,
                prefixIcon: SvgPicture.asset(AppVectors.password, fit: BoxFit.scaleDown),
                autoFillHintsList: const [
                  AutofillHints.password,
                ],
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
                    ),
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode4)
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
                  textEditingController: _againPasswordController,
                  focusNode: _focusNode4,
                  prefixIcon: SvgPicture.asset(AppVectors.password, fit: BoxFit.scaleDown),
                  inputActionLast: true,
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
        ),
      ],
    );
  }
}
