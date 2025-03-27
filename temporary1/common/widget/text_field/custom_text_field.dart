import 'package:flutter/material.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final bool inputActionLast;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? trailingIcon;
  final TextInputType? keyBoardType;
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool capitalize;
  final ValueChanged<String?>? onChanged;
  final bool autoFocus;
  final bool removePrefixSpace;
  final bool showBorder;
  final bool enableSuggestions;
  final ValueChanged<String?>? onSubmitted;
  final Iterable<String>? autoFillHintsList;

  const CustomTextField(
      {super.key,
      this.inputActionLast = false,
      required this.hintText,
      this.prefixIcon,
      this.keyBoardType,
      required this.textEditingController,
      this.focusNode,
      this.obscureText = false,
      this.capitalize = false,
      this.trailingIcon,
      this.onChanged,
      this.removePrefixSpace = false,
      this.autoFocus = false,
      this.showBorder = true,
      this.enableSuggestions = false,
      this.autoFillHintsList,
      this.onSubmitted
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        autocorrect: false,
        autofillHints: autoFillHintsList,
        enableIMEPersonalizedLearning: false,
        enableSuggestions: enableSuggestions,
        controller: textEditingController,
        focusNode: focusNode,
        autofocus: autoFocus,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
        textInputAction: inputActionLast ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            prefixIcon: SizedBox(height: 10, width: 10, child: prefixIcon),
            prefixIconConstraints: removePrefixSpace
                ? const BoxConstraints(
                    minWidth: 0,
                    minHeight: 2,
                  )
                : null,
            suffixIcon: SizedBox(
              height: 10,
              width: 10,
              child: trailingIcon,
            ),
            enabledBorder: showBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neutralOffWhiteColor),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neutralOffWhiteColor),
                  ),
            focusedBorder: showBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neutralOffWhiteColor),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.neutralOffWhiteColor),
                  ),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 18, color: AppColors.neutralOffWhiteColor)
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        // onSubmitted: onSubmitted,
      ),
    );
  }
}
