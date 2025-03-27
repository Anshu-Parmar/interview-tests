import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:startopreneur/presentation/auth/widgets/terms_conditions_widget.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final int height;

  const PrivacyPolicyWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'By Proceeding, you agree with the',
          style: TextStyle(fontSize: 12, color: Color(0xff787878)),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Color(0xff787878)),
            children: <TextSpan>[
              TextSpan(
                  text: 'Terms of use',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      CustomTermsAndConditionsBottomSheet.showModelBottomSheet(context, heading: "Terms & Conditions");
                    }),
              const TextSpan(text: ' and '),
              TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      CustomTermsAndConditionsBottomSheet.showModelBottomSheet(context, heading: "Privacy Policy");
                    }),
            ],
          ),
        ),
      ],
    );
  }
}
