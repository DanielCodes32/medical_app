import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/booking/data/models/doctor_availability_model.dart';

class BookingBottomBar extends StatelessWidget {
  final DoctorAvailabilityModel? selectedSlot;
  final VoidCallback? onConfirm;
  final bool isLoading;

  const BookingBottomBar({
    super.key,
    required this.selectedSlot,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedSlot != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected Slot Indicator Pill
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? Container(
                      key: const ValueKey("selected_pill"),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event_available_rounded,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          const Gap(6),
                          Text(
                            "${selectedSlot?.dayofweek ?? ''} • ${selectedSlot?.formattedTimeRange ?? ''}",
                            style: TextStyles.body1.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      key: const ValueKey("unselected_pill"),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            size: 14,
                            color: AppColors.bodycolor,
                          ),
                          const Gap(6),
                          Text(
                            "Select an available time slot to continue",
                            style: TextStyles.caption2.copyWith(
                              color: AppColors.bodycolor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Oval Shape Confirm Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (isSelected && !isLoading) ? onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.primaryColor
                      : AppColors.lightgrey1,
                  foregroundColor: isSelected
                      ? AppColors.backgroundColor
                      : AppColors.greycolor,
                  elevation: isSelected ? 4 : 0,
                  shadowColor: isSelected
                      ? AppColors.primaryColor.withValues(alpha: 0.4)
                      : Colors.transparent,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.backgroundColor,
                        ),
                      )
                    : Text(
                        "Confirm",
                        style: TextStyles.button.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.backgroundColor
                              : AppColors.greycolor,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
