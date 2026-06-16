import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';

class CustomFormField extends StatelessWidget {
  final int? keyboardtype;
  final bool? maxlines;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool? readOnly;
  final Widget? suffixIcon;
  final void Function()? onTap;
  const CustomFormField({
    super.key,

    this.keyboardtype,
    this.maxlines,
    this.validator,
    required this.hintText,
    this.controller,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTap: onTap,
          readOnly: readOnly ?? false,
          controller: controller,
          validator: validator,
          keyboardType: keyboardtype == 1
              ? TextInputType.emailAddress
              : keyboardtype == 2
              ? TextInputType.number
              : TextInputType.text,
          minLines: maxlines == false ? 3 : 1,
          maxLines: maxlines == false ? null : 1,

          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hint: Text(
              hintText ?? "",
              style: TextStyles.body1.copyWith(color: AppColors.greycolor),
            ),
          ),
        ),
      ],
    );
  }
}
