import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/booking/data/models/doctor_availability_model.dart';
import 'package:medical_app/features/booking/data/repo/booking_repo.dart';
import 'package:medical_app/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final String doctorId;
  final BookingRepo _bookingRepo;

  List<DoctorAvailabilityModel> availabilities = [];
  List<String> availableDays = [];
  String? selectedDay;
  DoctorAvailabilityModel? selectedSlot;
  bool isConfirming = false;

  BookingCubit({
    required this.doctorId,
    BookingRepo? bookingRepo,
  })  : _bookingRepo = bookingRepo ?? BookingRepo(),
        super(BookingInitial()) {
    fetchAvailabilities();
  }

  static int _getDayIndex(String day) {
    switch (day.toLowerCase().trim()) {
      case 'saturday':
        return 0;
      case 'sunday':
        return 1;
      case 'monday':
        return 2;
      case 'tuesday':
        return 3;
      case 'wednesday':
        return 4;
      case 'thursday':
        return 5;
      case 'friday':
        return 6;
      default:
        return 99;
    }
  }

  static String calculateScheduledAt(String dayOfWeek, String? startTime) {
    final now = DateTime.now();
    final dayLower = dayOfWeek.toLowerCase().trim();

    const weekdayMap = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };

    final targetWeekday = weekdayMap[dayLower] ?? DateTime.monday;

    int daysUntil = (targetWeekday - now.weekday) % 7;
    int hour = 9;
    int minute = 0;
    if (startTime != null && startTime.isNotEmpty) {
      final parts = startTime.split(':');
      if (parts.isNotEmpty) hour = int.tryParse(parts[0]) ?? 9;
      if (parts.length > 1) minute = int.tryParse(parts[1]) ?? 0;
    }

    if (daysUntil == 0) {
      final slotToday = DateTime(now.year, now.month, now.day, hour, minute);
      if (slotToday.isBefore(now)) {
        daysUntil = 7;
      }
    }

    final targetDate = now.add(Duration(days: daysUntil));
    final scheduledDateTime = DateTime.utc(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      hour,
      minute,
    );

    return scheduledDateTime.toIso8601String().replaceAll('.000Z', 'Z');
  }

  Future<void> fetchAvailabilities() async {
    emit(BookingLoading());
    final result = await _bookingRepo.getDoctorAvailabilities(doctorId);

    result.fold(
      (failure) {
        emit(
          BookingError(
            message: failure.message ?? 'Failed to load availabilities',
          ),
        );
      },
      (slots) {
        availabilities = slots;

        final daysSet = <String>{};
        for (final slot in slots) {
          if (slot.dayofweek != null && slot.dayofweek!.trim().isNotEmpty) {
            daysSet.add(slot.dayofweek!.trim());
          }
        }

        final daysList = daysSet.toList();
        daysList.sort((a, b) => _getDayIndex(a).compareTo(_getDayIndex(b)));
        availableDays = daysList;

        if (availableDays.isNotEmpty) {
          selectedDay = availableDays.firstWhere(
            (day) => slots.any(
              (s) =>
                  s.dayofweek?.toLowerCase() == day.toLowerCase() &&
                  !s.isregistered,
            ),
            orElse: () => availableDays.first,
          );
        } else {
          selectedDay = null;
        }

        selectedSlot = null;
        emit(
          BookingSuccess(
            availabilities: availabilities,
            selectedDay: selectedDay,
            selectedSlot: selectedSlot,
          ),
        );
      },
    );
  }

  void selectDay(String day) {
    if (selectedDay == day) return;
    selectedDay = day;

    if (selectedSlot != null &&
        selectedSlot!.dayofweek?.toLowerCase() != day.toLowerCase()) {
      selectedSlot = null;
    }
    emit(
      BookingSuccess(
        availabilities: availabilities,
        selectedDay: selectedDay,
        selectedSlot: selectedSlot,
      ),
    );
  }

  void selectSlot(DoctorAvailabilityModel slot) {
    if (slot.isregistered) return;

    if (selectedSlot?.id == slot.id) {
      selectedSlot = null;
    } else {
      selectedSlot = slot;
    }

    emit(
      BookingSuccess(
        availabilities: availabilities,
        selectedDay: selectedDay,
        selectedSlot: selectedSlot,
      ),
    );
  }

  Future<void> confirmAppointment() async {
    if (selectedSlot == null || isConfirming) return;

    if (!SharedPref.isProfileComplete()) {
      emit(
        BookingConfirmError(
          message:
              'Please complete your profile before booking an appointment.',
        ),
      );
      return;
    }

    final slot = selectedSlot!;
    final patientId = SharedPref.getSpecializedId();
    final docId = slot.doctorid ?? int.tryParse(doctorId) ?? 1;

    final scheduledAt = calculateScheduledAt(
      slot.dayofweek ?? selectedDay ?? 'Monday',
      slot.starttime,
    );

    isConfirming = true;
    emit(BookingConfirmLoading());

    final result = await _bookingRepo.confirmAppointment(
      patientId: patientId,
      doctorId: docId,
      scheduledAt: scheduledAt,
      notes: "",
      status: "pending",
    );

    isConfirming = false;

    result.fold(
      (failure) {
        emit(
          BookingConfirmError(
            message: failure.message ?? 'Failed to confirm appointment',
          ),
        );
        // Restore view state so the user can retry without losing their selection
        emit(
          BookingSuccess(
            availabilities: availabilities,
            selectedDay: selectedDay,
            selectedSlot: selectedSlot,
          ),
        );
      },
      (data) {
        // Mark the slot as registered
        final confirmedIndex =
            availabilities.indexWhere((s) => s.id == slot.id);
        if (confirmedIndex != -1) {
          final current = availabilities[confirmedIndex];
          availabilities[confirmedIndex] = DoctorAvailabilityModel(
            id: current.id,
            doctorid: current.doctorid,
            dayofweek: current.dayofweek,
            starttime: current.starttime,
            endtime: current.endtime,
            isregistered: true,
          );
        }

        selectedSlot = null;

        emit(
          BookingConfirmSuccess(
            message: "Appointment confirmed successfully!",
            scheduledAt: scheduledAt,
            confirmedSlot: slot,
          ),
        );
      },
    );
  }

  List<DoctorAvailabilityModel> get currentDaySlots {
    if (selectedDay == null) return [];
    final slots = availabilities
        .where(
          (s) => s.dayofweek?.toLowerCase() == selectedDay!.toLowerCase(),
        )
        .toList();

    // Sort chronologically by starttime
    slots.sort((a, b) => (a.starttime ?? '').compareTo(b.starttime ?? ''));
    return slots;
  }

  int get currentDayAvailableCount {
    return currentDaySlots.where((s) => !s.isregistered).length;
  }
}
