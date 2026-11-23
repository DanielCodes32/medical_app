import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/booking/data/models/doctor_availability_model.dart';

class TimeSlotCard extends StatelessWidget {
  final DoctorAvailabilityModel slot;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReserved = slot.isregistered;
    final timeRange = slot.formattedTimeRange;

    if (isReserved) {
      // Reserved slot: disabled with clean strikethrough across the whole time and a reserved badge below
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.containercolor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightgrey1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Time range displayed whole with red strikethrough line
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                timeRange,
                style: TextStyles.body1.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greycolor,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.redcolor,
                  decorationThickness: 2.0,
                ),
              ),
            ),
            const Gap(4),
            // Reserved indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.redcolor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.block_rounded,
                    size: 10,
                    color: AppColors.redcolor,
                  ),
                  const Gap(4),
                  Text(
                    "Reserved",
                    style: TextStyles.caption2.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redcolor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Available slot
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.lightgrey1,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.access_time_filled_rounded,
                  size: 13,
                  color: isSelected
                      ? AppColors.backgroundColor
                      : AppColors.primaryColor,
                ),
                const Gap(5),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      timeRange,
                      style: TextStyles.body1.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 13,
                        color: isSelected
                            ? AppColors.backgroundColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              isSelected ? "Selected" : "Available",
              style: TextStyles.caption2.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.backgroundColor.withValues(alpha: 0.9)
                    : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
