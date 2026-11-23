import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

class DoctorHeaderCard extends StatelessWidget {
  final DoctorDetailsResponse doctor;

  const DoctorHeaderCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final fullName = [doctor.firstname, doctor.lastname]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    final displayName =
        fullName.isNotEmpty ? 'Dr. $fullName' : 'Doctor Appointment';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightgrey1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 78,
              height: 78,
              color: AppColors.imagecolor,
              child: CachedNetworkImage(
                imageUrl: doctor.imageurl ?? "",
                errorWidget: (context, url, error) => Image.asset(
                  AppAssets.profile,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                if (doctor.specialization != null &&
                    doctor.specialization!.isNotEmpty)
                  Text(
                    doctor.specialization!,
                    style: TextStyles.body1.copyWith(
                      color: AppColors.bodycolor,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Gap(8),
                Row(
                  children: [
                    if (doctor.averagerating != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orangecolor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.orangecolor,
                              size: 15,
                            ),
                            const Gap(3),
                            Text(
                              doctor.averagerating!.toStringAsFixed(1),
                              style: TextStyles.caption2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.orangecolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                    ],
                    if (doctor.price != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "\$${doctor.price}/visit",
                          style: TextStyles.caption2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
