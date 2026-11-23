import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/doctor_home/presentation/cubit/doctor_home_cubit.dart';
import 'package:medical_app/features/doctor_home/presentation/cubit/doctor_home_state.dart';
import 'package:medical_app/features/doctor_home/presentation/widgets/appointment_card.dart';
import 'package:medical_app/features/doctor_home/presentation/widgets/doctor_home_header.dart';
import 'package:medical_app/features/doctor_home/presentation/widgets/doctor_stats_row.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkwhite,
      appBar: AppBar(
        title: Text(
          'Doctor Dashboard',
          style: TextStyles.title.copyWith(fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.redcolor,
            ),
            tooltip: 'Logout',
            onPressed: () async {
              await SharedPref.savetoken(null);
              if (context.mounted) {
                pushReplacement(context, Routes.login);
              }
            },
          ),
          const Gap(8),
        ],
      ),
      body: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
        builder: (context, state) {
          final cubit = context.read<DoctorHomeCubit>();

          if (state is DoctorHomeLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (state is DoctorHomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.redcolor,
                      size: 60,
                    ),
                    const Gap(16),
                    Text(
                      'Failed to load appointments',
                      style: TextStyles.title.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      state.message,
                      style: TextStyles.body1.copyWith(
                        color: AppColors.greycolor,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () => cubit.getDoctorData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyles.button.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final doctor = cubit.doctor;
          if (doctor == null) {
            return const SizedBox.shrink();
          }

          final appointments = cubit.filteredAppointments;

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => cubit.getDoctorData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: MyBodyView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Header
                    DoctorHomeHeader(doctor: doctor),
                    const Gap(18),

                    // Quick Stats Row
                    DoctorStatsRow(doctor: doctor),
                    const Gap(24),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Appointments",
                          style: TextStyles.title.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${cubit.allAppointments.length} Total",
                            style: TextStyles.caption2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),

                    // Filter Status Chips
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.filterOptions.length,
                        separatorBuilder: (context, index) => const Gap(8),
                        itemBuilder: (context, index) {
                          final filter = cubit.filterOptions[index];
                          final isSelected =
                              cubit.selectedFilter.toLowerCase() ==
                                  filter.toLowerCase();
                          final count = cubit.getCountForFilter(filter);

                          return GestureDetector(
                            onTap: () => cubit.setFilter(filter),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.lightgrey1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    filter,
                                    style: TextStyles.caption2.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.backgroundColor
                                          : AppColors.blackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Gap(6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.backgroundColor
                                              .withValues(alpha: 0.25)
                                          : AppColors.containercolor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyles.caption2.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? AppColors.backgroundColor
                                            : AppColors.bodycolor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(16),

                    // Appointments List
                    if (appointments.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.event_available_rounded,
                              size: 50,
                              color: AppColors.lightgrey,
                            ),
                            const Gap(12),
                            Text(
                              "No ${cubit.selectedFilter == 'All' ? '' : cubit.selectedFilter} appointments found",
                              style: TextStyles.body1.copyWith(
                                color: AppColors.greycolor,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return AppointmentCard(
                            appointment: appointment,
                            orderNumber: index + 1,
                          );
                        },
                      ),
                    const Gap(24),
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
