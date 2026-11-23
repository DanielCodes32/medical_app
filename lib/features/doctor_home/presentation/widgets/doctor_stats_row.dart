import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

class DoctorStatsRow extends StatelessWidget {
  final DoctorDetailsResponse doctor;

  const DoctorStatsRow({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.calendar_today_rounded,
          iconColor: AppColors.primaryColor,
          value: "${doctor.appointments ?? 0}",
          label: "Appointments",
        ),
        const Gap(10),
        _buildStatCard(
          icon: Icons.people_alt_rounded,
          iconColor: AppColors.purple,
          value: "${doctor.patients ?? 0}",
          label: "Patients",
        ),
        const Gap(10),
        _buildStatCard(
          icon: Icons.star_rounded,
          iconColor: AppColors.orangecolor,
          value: doctor.averagerating != null
              ? doctor.averagerating!.toStringAsFixed(1)
              : "0.0",
          label: "Rating",
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightgrey1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Gap(8),
            Text(
              value,
              style: TextStyles.title.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const Gap(2),
            Text(
              label,
              style: TextStyles.caption2.copyWith(
                color: AppColors.bodycolor,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
