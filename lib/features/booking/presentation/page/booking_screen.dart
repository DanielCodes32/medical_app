import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:medical_app/features/booking/presentation/cubit/booking_state.dart';
import 'package:medical_app/features/booking/presentation/widgets/booking_bottom_bar.dart';
import 'package:medical_app/features/booking/presentation/widgets/day_selector_chips.dart';
import 'package:medical_app/features/booking/presentation/widgets/doctor_header_card.dart';
import 'package:medical_app/features/booking/presentation/widgets/time_slot_card.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

class BookingScreen extends StatelessWidget {
  final DoctorDetailsResponse doctor;

  const BookingScreen({super.key, required this.doctor});

  void _showSuccessDialog(
    BuildContext context,
    BookingConfirmSuccess successState,
  ) {
    final doctorName = [doctor.firstname, doctor.lastname]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryColor,
                  size: 46,
                ),
              ),
              const Gap(16),
              Text(
                "Appointment Confirmed!",
                style: TextStyles.title.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                "Your appointment has been booked successfully with status: Pending.",
                style: TextStyles.body1.copyWith(
                  color: AppColors.bodycolor,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.containercolor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.lightgrey1),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Doctor",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                          ),
                        ),
                        Text(
                          doctorName.isNotEmpty ? "Dr. $doctorName" : "Doctor",
                          style: TextStyles.caption2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.lightgrey1, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Day & Time",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                          ),
                        ),
                        Text(
                          "${successState.confirmedSlot?.dayofweek ?? ''} • ${successState.confirmedSlot?.formattedTimeRange ?? ''}",
                          style: TextStyles.caption2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    pushToBase(context, Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: const StadiumBorder(),
                    elevation: 2,
                  ),
                  child: Text(
                    "Done",
                    style: TextStyles.button.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkwhite,
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyles.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmSuccess) {
            _showSuccessDialog(context, state);
          } else if (state is BookingConfirmError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.redcolor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Text(
                  state.message,
                  style: TextStyles.body1.copyWith(
                    color: AppColors.backgroundColor,
                  ),
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();

          if (state is BookingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (state is BookingError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.redcolor,
                      size: 64,
                    ),
                    const Gap(16),
                    Text(
                      'Failed to load availabilities',
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
                      onPressed: () => cubit.fetchAvailabilities(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
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

          final slots = cubit.currentDaySlots;
          final availableCount = cubit.currentDayAvailableCount;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MyBodyView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Info Header
                  DoctorHeaderCard(doctor: doctor),
                  const Gap(22),

                  // Day Selection Section
                  if (cubit.availableDays.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                            const Gap(8),
                            Text(
                              "Select Day",
                              style: TextStyles.title.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.containercolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${cubit.availableDays.length} days",
                            style: TextStyles.caption2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodycolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    DaySelectorChips(
                      days: cubit.availableDays,
                      selectedDay: cubit.selectedDay,
                      onDaySelected: (day) => cubit.selectDay(day),
                      getSlotCountForDay: (day) {
                        return cubit.availabilities
                            .where(
                              (s) =>
                                  s.dayofweek?.toLowerCase() ==
                                      day.toLowerCase() &&
                                  !s.isregistered,
                            )
                            .length;
                      },
                    ),
                    const Gap(22),
                  ],

                  // Time Slots Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 17,
                            color: AppColors.primaryColor,
                          ),
                          const Gap(8),
                          Text(
                            "Available Time Slots",
                            style: TextStyles.title.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      if (slots.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: availableCount > 0
                                ? AppColors.secondaryColor
                                : AppColors.containercolor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "$availableCount open",
                            style: TextStyles.caption2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: availableCount > 0
                                  ? AppColors.primaryColor
                                  : AppColors.darkgreycolor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(14),

                  // Slots Grid
                  if (slots.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightgrey1),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.event_busy_rounded,
                            size: 44,
                            color: AppColors.lightgrey,
                          ),
                          const Gap(12),
                          Text(
                            "No time slots available for ${cubit.selectedDay ?? "this day"}",
                            style: TextStyles.body1.copyWith(
                              color: AppColors.greycolor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: slots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 64,
                      ),
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        final isSelected = cubit.selectedSlot?.id == slot.id;

                        return TimeSlotCard(
                          slot: slot,
                          isSelected: isSelected,
                          onTap: () => cubit.selectSlot(slot),
                        );
                      },
                    ),

                  const Gap(22),

                  // Informational tip card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.containercolor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightgrey1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.bodycolor,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            "Reserved slots are crossed out with a line. Choose any available slot and tap Confirm to proceed.",
                            style: TextStyles.caption2.copyWith(
                              color: AppColors.bodycolor,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();
          return BookingBottomBar(
            selectedSlot: cubit.selectedSlot,
            isLoading: cubit.isConfirming || state is BookingConfirmLoading,
            onConfirm: () => cubit.confirmAppointment(),
          );
        },
      ),
    );
  }
}
