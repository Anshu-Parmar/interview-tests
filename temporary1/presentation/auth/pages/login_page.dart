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
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/presentation/auth/cubit/credential_cubit.dart';
import 'package:startopreneur/presentation/auth/cubit/password_visible_cubit.dart';

class LogInPage extends StatefulWidget {
  ///FOR BOOKMARK SAVING
  final BookMarkItem? bookMarkItem;
  final int? tabIndex;

  const LogInPage({super.key, this.bookMarkItem, this.tabIndex});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  List<bool> canBePressed = [true, true, true];

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() => _scrollToFocusedNode(_focusNode1));
    _focusNode2.addListener(() => _scrollToFocusedNode(_focusNode2));
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
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          maintainBottomViewPadding: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocProvider<PasswordVisibleCubit>(
              create: (context) => PasswordVisibleCubit(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            'Log In',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _textFields(),
                          _forgotPassword(),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocProvider(
                            create: (context) => CredentialCubit(),
                            child: BlocBuilder<CredentialCubit, CredentialState>(
                              builder: (context, state) {
                                if (state is CredentialLoading) {
                                  canBePressed = List.from(
                                    canBePressed.asMap().map((index, val) {
                                      if (index == 0) {
                                        return MapEntry(index, true);
                                      } else {
                                        return MapEntry(index, false);
                                      }
                                    }).values,
                                  );
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  canBePressed = [true, true, true];
                                }
                                return CustomElevatedButton(
                                  title: "Log In",
                                  elevation: 2,
                                  onPressed: () {
                                    if (_emailController.text.isEmpty) {
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
                                    } else {
                                      if (canBePressed[0]) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        BlocProvider.of<CredentialCubit>(context).signInSubmit(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            context: context,
                                            bookMarkItem: widget.bookMarkItem,
                                            tabIndex: widget.tabIndex);
                                      }
                                    }
                                  });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _customDivider(),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocProvider(
                            create: (context) => CredentialCubit(),
                            child: BlocBuilder<CredentialCubit, CredentialState>(
                              builder: (context, state) {
                                if (state is CredentialLoading) {
                                  canBePressed = List.from(
                                    canBePressed.asMap().map((index, val) {
                                      if (index == 1) {
                                        return MapEntry(index, true);
                                      } else {
                                        return MapEntry(index, false);
                                      }
                                    }).values,
                                  );
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  canBePressed = [true, true, true];
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    if (canBePressed[1]) {
                                      BlocProvider.of<CredentialCubit>(context).googleSignInSubmit(
                                          context: context,
                                          bookMarkItem: widget.bookMarkItem,
                                          tabIndex: widget.tabIndex
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.neutralDarkColor ,
                                    minimumSize: const Size.fromHeight(47),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(color: Colors.transparent)
                                    )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        height: 21,
                                        width: 21,
                                        AppVectors.google
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          color: context.isDarkMode ?  AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                                        ),
                                      )
                                    ],
                                  )
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocProvider(
                            create: (context) => CredentialCubit(),
                            child: BlocBuilder<CredentialCubit, CredentialState>(
                              builder: (context, state) {
                                if (state is CredentialLoading) {
                                  canBePressed = List.from(
                                    canBePressed.asMap().map((index, val) {
                                      if (index == 2) {
                                        return MapEntry(index, true);
                                      } else {
                                        return MapEntry(index, false);
                                      }
                                    }).values,
                                  );
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  canBePressed = [true, true, true];
                                }
                                return ElevatedButton(
                                    onPressed: () {
                                      if (canBePressed[2]) {
                                        BlocProvider.of<CredentialCubit>(context).appleSignInSubmit(
                                          context: context,
                                          bookMarkItem: widget.bookMarkItem,
                                          tabIndex: widget.tabIndex,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      backgroundColor:  context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.neutralDarkColor,
                                      minimumSize: const Size.fromHeight(44),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(color: Colors.transparent)
                                      )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          AppVectors.apple,
                                          height: 21,
                                          width: 21,
                                          colorFilter: ColorFilter.mode(
                                            context.isDarkMode ?  AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                                            BlendMode.srcIn
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Sign in with Apple',
                                          style: TextStyle(
                                            color: context.isDarkMode ?  AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                                          ),
                                        )
                                      ],
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Don\'t have an account ? ',
                              style: const TextStyle(fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Sign up',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context,
                                          RouteNames.signup,
                                          arguments: HomePageArguments(widget.bookMarkItem, widget.tabIndex)
                                      )
                                )
                              ],
                            ),
                          ),
                          Align(
                            heightFactor: 5,
                            child: PrivacyPolicyWidget(
                              height: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  static Widget _customDivider() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: const SizedBox(),
          ),
          Expanded(
            flex: 5,
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "OR",
              style: TextStyle(fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Divider(),
          ),
          Expanded(
            flex: 2,
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  _textFields() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          BlocBuilder<PasswordVisibleCubit, PasswordVisibleState>(
            builder: (context, state) {
              return CustomTextField(
                hintText: 'Enter Password',
                keyBoardType: TextInputType.visiblePassword,
                obscureText: state is PasswordVisibilityUpdated ? state.isVisible : true,
                inputActionLast: true,
                textEditingController: _passwordController,
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, RouteNames.forgotPwd),
          child: const Text(
            'Forgot Password ?',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
