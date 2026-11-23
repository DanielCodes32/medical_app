import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/features/auth/presentation/page/login_screen.dart';
import 'package:medical_app/features/auth/presentation/page/register_screen.dart';
import 'package:medical_app/features/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:medical_app/features/doctor_details/presentation/page/doctor_details_screen.dart';
import 'package:medical_app/features/main_app_screen/base_home.dart';
import 'package:medical_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:medical_app/features/search/presentation/page/search_screen.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';
import 'package:medical_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:medical_app/features/booking/presentation/page/booking_screen.dart';
import 'package:medical_app/features/doctor_home/presentation/cubit/doctor_home_cubit.dart';
import 'package:medical_app/features/doctor_home/presentation/page/doctor_home_screen.dart';
import 'package:medical_app/features/doctor_profile/presentation/page/doctor_profile_setup_screen.dart';
import 'package:medical_app/features/patient_details/presentation/cubit/patient_details_cubit.dart';
import 'package:medical_app/features/patient_details/presentation/page/patient_details_screen.dart';
import 'package:medical_app/features/patient_profile/presentation/cubit/patient_profile_cubit.dart';
import 'package:medical_app/features/patient_profile/presentation/page/patient_profile_screen.dart';
import 'package:medical_app/features/splash/splash_screen.dart';
import 'package:medical_app/features/welcome/welcome_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final routes = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(path: Routes.home, builder: (context, state) => const BaseHome()),
      GoRoute(
        path: Routes.search,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return BlocProvider<SearchCubit>(
            create: (BuildContext context) => SearchCubit(initialQuery: query),
            child: const SearchScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.doctorDetails,
        builder: (context, state) => BlocProvider<DoctorDetailsCubit>(
          create: (BuildContext context) {
            return DoctorDetailsCubit(id: state.extra.toString());
          },
          child: const DoctorDetailsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.doctorProfileSetup,
        builder: (context, state) => const DoctorProfileSetupScreen(),
      ),
      GoRoute(
        path: Routes.booking,
        builder: (context, state) {
          // Guard: If patient profile is not complete, redirect to patient profile page
          if (!SharedPref.isProfileComplete()) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              mydiag(
                context,
                "Please complete your profile before booking an appointment",
                AppColors.orangecolor,
              );
              pushReplacement(context, Routes.patientProfile);
            });
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          }

          final extra = state.extra;
          final DoctorDetailsResponse doctor;
          if (extra is DoctorDetailsResponse) {
            doctor = extra;
          } else if (extra is Datum) {
            doctor = DoctorDetailsResponse(
              id: extra.id ?? extra.doctorid,
              firstname: extra.firstname,
              lastname: extra.lastname,
              specialization: extra.specialization,
              price: extra.price?.toInt(),
              imageurl: extra.imageurl,
              averagerating: extra.averagerating,
            );
          } else {
            doctor = DoctorDetailsResponse(
              id: int.tryParse(extra?.toString() ?? ''),
            );
          }
          return BlocProvider<BookingCubit>(
            create: (context) =>
                BookingCubit(doctorId: (doctor.id ?? '').toString()),
            child: BookingScreen(doctor: doctor),
          );
        },
      ),
      GoRoute(
        path: Routes.doctorHome,
        builder: (context, state) => BlocProvider<DoctorHomeCubit>(
          create: (context) => DoctorHomeCubit(
            doctorId: state.extra?.toString(),
          ),
          child: const DoctorHomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.patientDetails,
        builder: (context, state) {
          final patientId = state.extra?.toString() ?? '';
          return BlocProvider<PatientDetailsCubit>(
            create: (context) => PatientDetailsCubit(patientId: patientId),
            child: PatientDetailsScreen(patientId: patientId),
          );
        },
      ),
      GoRoute(
        path: Routes.patientProfile,
        builder: (context, state) => BlocProvider<PatientProfileCubit>(
          create: (context) => PatientProfileCubit(),
          child: const PatientProfileScreen(),
        ),
      ),
    ],
  );
}
