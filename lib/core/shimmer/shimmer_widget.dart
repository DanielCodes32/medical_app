import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightgrey,
      highlightColor: AppColors.backgroundColor,
      child: child,
    );
  }
}
