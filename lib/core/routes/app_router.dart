import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/features/auth/presentation/page/login_screen.dart';
import 'package:medical_app/features/auth/presentation/page/register_screen.dart';
import 'package:medical_app/features/main_app_screen/base_home.dart';
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
    ],
  );
}
