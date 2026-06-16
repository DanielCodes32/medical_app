import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';

class FilledIconButton extends StatelessWidget {
  final Color? fillcolor;
  final Widget iconData;
  final VoidCallback? onPressed;

  const FilledIconButton({
    super.key,
    this.fillcolor,
    required this.iconData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fillcolor ?? AppColors.backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(width: 40, height: 40, child: Center(child: iconData)),
      ),
    );
  }
}
