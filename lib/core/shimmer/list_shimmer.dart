import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/shimmer/shimmer_widget.dart';
import 'package:medical_app/core/styles/app_colors.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({
    super.key,
    this.itemCount = 6,
    this.scrollDirection = Axis.vertical,
  });

  final int itemCount;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        scrollDirection: scrollDirection,
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Gap(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 15,
                      color: AppColors.backgroundColor,
                    ),
                    const Gap(10),
                    Container(
                      width: 150,
                      height: 12,
                      color: AppColors.backgroundColor,
                    ),
                    const Gap(10),
                    Container(
                      width: 80,
                      height: 12,
                      color: AppColors.backgroundColor,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
