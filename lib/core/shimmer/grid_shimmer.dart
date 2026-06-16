import 'package:flutter/material.dart';
import 'package:medical_app/core/shimmer/shimmer_widget.dart';

class GridShimmer extends StatelessWidget {
  const GridShimmer({
    super.key,
    this.itemCount = 6,
    required this.shimmerWidget,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
  });

  final int itemCount;
  final Widget shimmerWidget;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: childAspectRatio,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        itemBuilder: (context, index) {
          return shimmerWidget;
        },
        itemCount: itemCount,
      ),
    );
  }
}
