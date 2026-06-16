import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPic extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  const SvgPic({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
