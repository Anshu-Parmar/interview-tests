import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/toasts.dart';
import 'package:startopreneur/common/helper/validation.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/common/widget/text_field/custom_text_field.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/constants/messages.dart';
import 'package:startopreneur/presentation/auth/cubit/credential_cubit.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.2;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                BlocProvider(
                  create: (context) => CredentialCubit(),
                  child: BlocBuilder<CredentialCubit, CredentialState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 72,
                            width: 72,
                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.logo))),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          state is CredentialLoaded
                              ? Text(
                                  'Reset Email Sent!!',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                                )
                              : const Text(
                                  'Forgot Password ',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                                ),
                          const SizedBox(
                            height: 12,
                          ),
                          state is CredentialLoaded
                              ? const Text(
                                  'Reset Password link has been',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff696969)),
                                )
                              : const Text(
                                  'Enter email address and we will',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff696969)),
                                ),
                          state is CredentialLoaded
                              ? Text(
                                  'sent to email ${_emailController.text.trim()}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff696969)),
                                )
                              : const Text(
                                  'send you a reset password link',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff696969)),
                                ),
                          const SizedBox(
                            height: 40,
                          ),
                          _textFields(context),
                          const SizedBox(
                            height: 20,
                          ),
                          state is CredentialLoaded
                              ? const SizedBox()
                              : CustomElevatedButton(
                                  title: "Submit",
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
                                    } else {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      BlocProvider.of<CredentialCubit>(context)
                                          .forgotPassword(email: _emailController.text, context: context);
                                    }
                                  }),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: height % 20,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.adaptive.arrow_back_rounded,
                        size: 25,
                        // color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ));
  }

  _textFields(BuildContext context) {
    return Column(
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
          inputActionLast: true,
          autoFocus: true,
          textEditingController: _emailController,
          prefixIcon: SvgPicture.asset(AppVectors.email, fit: BoxFit.scaleDown),
          autoFillHintsList: const [
            AutofillHints.email,
          ],
        ),
      ],
    );
  }
}
