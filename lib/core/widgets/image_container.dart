import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';

class ImageContainer extends StatelessWidget {
  final Widget image;
  final double? height;
  final double? width;

  const ImageContainer({
    super.key,
    required this.image,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 160,
      height: height ?? 160,
      decoration: BoxDecoration(
        color: AppColors.imagecolor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: image),
    );
  }
}
