import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

class DoctorHomeHeader extends StatelessWidget {
  final DoctorDetailsResponse doctor;

  const DoctorHomeHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final name = [doctor.firstname, doctor.lastname]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    final displayName = name.isNotEmpty ? 'Dr. $name' : 'Doctor';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 65,
              height: 65,
              color: AppColors.imagecolor,
              child: CachedNetworkImage(
                imageUrl: doctor.imageurl ?? '',
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
                  "Welcome Back,",
                  style: TextStyles.caption2.copyWith(
                    color: AppColors.bodycolor,
                    fontSize: 13,
                  ),
                ),
                const Gap(2),
                Text(
                  displayName,
                  style: TextStyles.title.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(4),
                Row(
                  children: [
                    if (doctor.specialization != null &&
                        doctor.specialization!.isNotEmpty) ...[
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
                          doctor.specialization!,
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(8),
                    ],
                    if (doctor.department != null &&
                        doctor.department!.isNotEmpty)
                      Flexible(
                        child: Text(
                          doctor.department!,
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
