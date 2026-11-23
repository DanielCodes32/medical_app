import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/availability.dart';

class AppointmentCard extends StatelessWidget {
  final Availability appointment;
  final int orderNumber;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.orderNumber,
  });

  void _onCardTap(BuildContext context) {
    if (appointment.patientid != null) {
      pushTo(
        context,
        Routes.patientDetails,
        extra: appointment.patientid.toString(),
      );
    } else {
      mydiag(
        context,
        "Patient information is not available",
        AppColors.redcolor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = appointment.isConfirmed
        ? AppColors.primaryColor
        : (appointment.isPending ? AppColors.orangecolor : AppColors.redcolor);

    final statusBgColor = statusColor.withValues(alpha: 0.12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onCardTap(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightgrey1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Date, Time & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date and Time
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            const Gap(6),
                            Text(
                              appointment.formattedDate,
                              style: TextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        if (appointment.formattedTime.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.primaryColor,
                              ),
                              const Gap(4),
                              Text(
                                appointment.formattedTime,
                                style: TextStyles.body1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Status Chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          appointment.isConfirmed
                              ? Icons.check_circle_rounded
                              : (appointment.isPending
                                  ? Icons.hourglass_top_rounded
                                  : Icons.info_outline_rounded),
                          size: 12,
                          color: statusColor,
                        ),
                        const Gap(4),
                        Text(
                          appointment.status?.toUpperCase() ?? "UNKNOWN",
                          style: TextStyles.caption2.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: AppColors.lightgrey1, height: 1),
              ),

              // Patient Info Row (Numbered in order of appointments, ID removed)
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.secondaryColor,
                    child: Text(
                      "#$orderNumber",
                      style: TextStyles.caption2.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientDisplayNameWithOrder(orderNumber),
                          style: TextStyles.title.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const Gap(2),
                        Row(
                          children: [
                            Text(
                              "Appointment #$orderNumber",
                              style: TextStyles.caption2.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              "•",
                              style: TextStyles.caption2.copyWith(
                                color: AppColors.greycolor,
                                fontSize: 10,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              "Tap for details",
                              style: TextStyles.caption2.copyWith(
                                color: AppColors.bodycolor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              // Notes
              if (appointment.notes != null &&
                  appointment.notes!.trim().isNotEmpty) ...[
                const Gap(12),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.containercolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notes_rounded,
                        size: 16,
                        color: AppColors.bodycolor,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          appointment.notes!,
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.black1,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
