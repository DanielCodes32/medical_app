import 'package:flutter/material.dart';
import 'package:medical_app/core/widgets/svg_pic.dart';

class ColoredContainer extends StatelessWidget {
  final Color color;
  final String assetName;
  const ColoredContainer({
    super.key,
    required this.color,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 90,
      width: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: SvgPic(assetName: assetName)),
    );
  }
}
