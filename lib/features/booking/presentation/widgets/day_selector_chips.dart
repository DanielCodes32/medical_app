import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';

class DaySelectorChips extends StatelessWidget {
  final List<String> days;
  final String? selectedDay;
  final ValueChanged<String> onDaySelected;
  final int Function(String day)? getSlotCountForDay;

  const DaySelectorChips({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
    this.getSlotCountForDay,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: days.length,
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected =
              selectedDay?.toLowerCase() == day.toLowerCase();
          final count = getSlotCountForDay != null ? getSlotCountForDay!(day) : null;

          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(24), // Oval pill shape
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.lightgrey1,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day,
                      style: TextStyles.body1.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 13,
                        color: isSelected
                            ? AppColors.backgroundColor
                            : AppColors.blackColor,
                      ),
                    ),
                    if (count != null && count > 0) ...[
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.backgroundColor.withValues(alpha: 0.25)
                              : AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyles.caption2.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.backgroundColor
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
