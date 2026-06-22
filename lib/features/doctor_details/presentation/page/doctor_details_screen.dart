import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:medical_app/features/doctor_details/presentation/cubit/doctor_details_states.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Details',
          style: TextStyles.title.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          final cubit = context.read<DoctorDetailsCubit>();
          final doctor = cubit.doctorDetails?.data;

          if (state is DoctorDetailsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 60,
                  ),
                  const Gap(16),
                  Text(
                    'Failed to load doctor details',
                    style: TextStyles.title.copyWith(fontSize: 18),
                  ),
                  const Gap(8),
                  ElevatedButton(
                    onPressed: () => cubit.getDoctorDetails(cubit.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text('Retry', style: TextStyles.button.copyWith(fontSize: 14)),
                  ),
                ],
              ),
            );
          }

          if (state is DoctorDetailsLoadingState || doctor == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MyBodyView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Info Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 100,
                            height: 100,
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
                                "Dr. ${doctor.firstname ?? ""} ${doctor.lastname ?? ""}",
                                style: TextStyles.title.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(4),
                              Text(
                                doctor.specialization ?? "General Practice",
                                style: TextStyles.caption2.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: doctor.averagerating ?? 0.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    ignoreGestures: true,
                                    itemCount: 5,
                                    itemSize: 16,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const Gap(4),
                                  Text(
                                    "${doctor.averagerating ?? 0.0} (${doctor.ratingcount ?? 0})",
                                    style: TextStyles.caption2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Text(
                                "Price: \$${doctor.price ?? 0}",
                                style: TextStyles.caption2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        icon: Icons.people_outline,
                        color: AppColors.purple,
                        value: "${doctor.patients ?? 0}+",
                        label: "Patients",
                      ),
                      _buildStatCard(
                        icon: Icons.calendar_month_outlined,
                        color: AppColors.green,
                        value: "${doctor.appointments ?? 0}+",
                        label: "Appointments",
                      ),
                      _buildStatCard(
                        icon: Icons.star_outline,
                        color: AppColors.orange,
                        value: doctor.averagerating != null
                            ? "${doctor.averagerating}"
                            : "0.0",
                        label: "Rating",
                      ),
                    ],
                  ),
                  const Gap(28),

                  Text(
                    "About Doctor",
                    style: TextStyles.title.copyWith(fontSize: 18),
                  ),
                  const Gap(10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          icon: Icons.local_hospital_outlined,
                          title: "Department",
                          value: doctor.department ?? "General Medicine",
                        ),
                        const Divider(height: 20, color: AppColors.lightgrey1),
                        _buildDetailRow(
                          icon: Icons.badge_outlined,
                          title: "License Number",
                          value: doctor.licensenumber ?? "N/A",
                        ),
                        const Divider(height: 20, color: AppColors.lightgrey1),
                        _buildDetailRow(
                          icon: Icons.phone_outlined,
                          title: "Contact",
                          value: doctor.phone ?? "N/A",
                        ),
                      ],
                    ),
                  ),
                  const Gap(28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Patient Reviews",
                        style: TextStyles.title.copyWith(fontSize: 18),
                      ),
                      Text(
                        "${doctor.ratings?.length ?? 0} reviews",
                        style: TextStyles.caption2.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  if (doctor.ratings == null || doctor.ratings!.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: Text(
                        "No reviews yet",
                        style: TextStyles.caption2.copyWith(fontSize: 14),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctor.ratings!.length,
                      separatorBuilder: (context, index) => const Gap(12),
                      itemBuilder: (context, index) {
                        final rating = doctor.ratings![index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                                        child: const Icon(
                                          Icons.person,
                                          size: 18,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        (rating.firstname != null && rating.lastname != null)
                                            ? "${rating.firstname} ${rating.lastname}"
                                            : "Patient #${rating.patientid}",
                                        style: TextStyles.caption2.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  RatingBar.builder(
                                    initialRating: rating.rate ?? 0.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    ignoreGestures: true,
                                    itemCount: 5,
                                    itemSize: 12,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Text(
                                rating.comment ?? "No comment provided.",
                                style: TextStyles.caption2.copyWith(
                                  color: AppColors.bodycolor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const Gap(40),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          final cubit = context.read<DoctorDetailsCubit>();
          final doctor = cubit.doctorDetails?.data;
          if (doctor == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Book Now",
                  style: TextStyles.button.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const Gap(10),
            Text(
              value,
              style: TextStyles.title.copyWith(fontSize: 16),
            ),
            const Gap(2),
            Text(
              label,
              style: TextStyles.caption2.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.caption2.copyWith(
                color: AppColors.greycolor,
                fontSize: 11,
              ),
            ),
            const Gap(2),
            Text(
              value,
              style: TextStyles.title1.copyWith(
                fontSize: 14,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}