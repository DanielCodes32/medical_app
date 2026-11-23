import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/patient_details/data/models/patient_details_model.dart';
import 'package:medical_app/features/patient_details/presentation/cubit/patient_details_cubit.dart';
import 'package:medical_app/features/patient_details/presentation/cubit/patient_details_state.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkwhite,
      appBar: AppBar(
        title: Text(
          'Patient Details',
          style: TextStyles.title.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<PatientDetailsCubit, PatientDetailsState>(
        builder: (context, state) {
          final cubit = context.read<PatientDetailsCubit>();

          if (state is PatientDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (state is PatientDetailsError) {
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
                      'Failed to load patient information',
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
                      onPressed: () => cubit.getPatientDetails(),
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

          final patient = cubit.patient;
          if (patient == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => cubit.getPatientDetails(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: MyBodyView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Profile Header Card
                    _buildPatientHeader(patient),
                    const Gap(16),

                    // Quick Stats / Vitals Row
                    _buildQuickStats(patient),
                    const Gap(20),

                    // Contact & Personal Information Card
                    _buildSectionHeader("Contact & Personal Information"),
                    const Gap(10),
                    _buildContactCard(patient),
                    const Gap(20),

                    // Medical Details Card
                    _buildSectionHeader("Medical Information"),
                    const Gap(10),
                    _buildMedicalCard(patient),
                    const Gap(32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientHeader(PatientDetailsModel patient) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 75,
              height: 75,
              color: AppColors.imagecolor,
              child: (patient.imageurl != null && patient.imageurl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: patient.imageurl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        AppAssets.profile,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AppAssets.profile,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const Gap(16),

          // Name, Age & Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.fullName,
                  style: TextStyles.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (patient.username != null &&
                    patient.username!.isNotEmpty &&
                    patient.fullName != patient.username) ...[
                  const Gap(2),
                  Text(
                    "@${patient.username}",
                    style: TextStyles.caption2.copyWith(
                      color: AppColors.bodycolor,
                      fontSize: 12,
                    ),
                  ),
                ],
                const Gap(8),

                // Badges Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (patient.gender != null &&
                        patient.gender!.trim().isNotEmpty)
                      _buildBadge(
                        label: patient.gender!,
                        color: AppColors.primaryColor,
                        bgColor: AppColors.secondaryColor,
                      ),
                    if (patient.age != null)
                      _buildBadge(
                        label: "${patient.age} yrs",
                        color: AppColors.purple,
                        bgColor: AppColors.purple.withValues(alpha: 0.1),
                      ),
                    if (patient.bloodgroup != null &&
                        patient.bloodgroup!.trim().isNotEmpty)
                      _buildBadge(
                        label: "Blood: ${patient.bloodgroup}",
                        color: AppColors.redcolor,
                        bgColor: AppColors.redcolor.withValues(alpha: 0.1),
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

  Widget _buildBadge({
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyles.caption2.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildQuickStats(PatientDetailsModel patient) {
    return Row(
      children: [
        _buildStatBox(
          icon: Icons.cake_outlined,
          iconColor: AppColors.primaryColor,
          value: patient.age != null ? "${patient.age}" : "N/A",
          label: "Age (yrs)",
        ),
        const Gap(10),
        _buildStatBox(
          icon: Icons.person_outline_rounded,
          iconColor: AppColors.purple,
          value: patient.gender?.isNotEmpty == true
              ? patient.gender![0].toUpperCase() +
                  patient.gender!.substring(1).toLowerCase()
              : "N/A",
          label: "Gender",
        ),
        const Gap(10),
        _buildStatBox(
          icon: Icons.water_drop_outlined,
          iconColor: AppColors.redcolor,
          value: patient.bloodgroup?.isNotEmpty == true
              ? patient.bloodgroup!
              : "N/A",
          label: "Blood Group",
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const Gap(6),
            Text(
              value,
              style: TextStyles.title.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyles.title.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.blackColor,
      ),
    );
  }

  Widget _buildContactCard(PatientDetailsModel patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
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
          _buildInfoRow(
            icon: Icons.phone_outlined,
            iconColor: AppColors.primaryColor,
            label: "Phone Number",
            value: patient.phone?.isNotEmpty == true
                ? patient.phone!
                : "Not provided",
          ),
          const Divider(color: AppColors.lightgrey1, height: 20),
          _buildInfoRow(
            icon: Icons.email_outlined,
            iconColor: AppColors.primaryColor,
            label: "Email Address",
            value: patient.email?.isNotEmpty == true
                ? patient.email!
                : "Not provided",
          ),
          const Divider(color: AppColors.lightgrey1, height: 20),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.primaryColor,
            label: "Address & City",
            value: patient.fullLocation,
          ),
          if (patient.emergencycontact != null &&
              patient.emergencycontact!.trim().isNotEmpty) ...[
            const Divider(color: AppColors.lightgrey1, height: 20),
            _buildInfoRow(
              icon: Icons.contact_emergency_outlined,
              iconColor: AppColors.redcolor,
              label: "Emergency Contact",
              value: patient.emergencycontact!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicalCard(PatientDetailsModel patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
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
          _buildInfoRow(
            icon: Icons.medical_services_outlined,
            iconColor: AppColors.purple,
            label: "Blood Group",
            value: patient.bloodgroup?.isNotEmpty == true
                ? patient.bloodgroup!
                : "Not specified",
          ),
          const Divider(color: AppColors.lightgrey1, height: 20),
          _buildInfoRow(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.orangecolor,
            label: "Allergies",
            value: patient.allergies?.isNotEmpty == true
                ? patient.allergies!
                : "None reported",
          ),
          const Divider(color: AppColors.lightgrey1, height: 20),
          _buildInfoRow(
            icon: Icons.history_rounded,
            iconColor: AppColors.primaryColor,
            label: "Chronic Conditions",
            value: patient.chronicdiseases?.isNotEmpty == true
                ? patient.chronicdiseases!
                : "None reported",
          ),
          const Divider(color: AppColors.lightgrey1, height: 20),
          _buildInfoRow(
            icon: Icons.assignment_outlined,
            iconColor: AppColors.greycolor,
            label: "Medical History / Notes",
            value: (patient.medicalhistory?.isNotEmpty == true)
                ? patient.medicalhistory!
                : ((patient.notes?.isNotEmpty == true)
                    ? patient.notes!
                    : "No past medical records available"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.caption2.copyWith(
                  color: AppColors.greycolor,
                  fontSize: 12,
                ),
              ),
              const Gap(3),
              Text(
                value,
                style: TextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

