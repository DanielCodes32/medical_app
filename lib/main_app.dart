import 'package:chili_debug_view/chili_debug_view.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/routes/app_router.dart';
import 'package:medical_app/core/styles/themes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darktheme,
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return DebugView(
          app: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(AppAssets.bg),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent, // important!
              resizeToAvoidBottomInset: false,
              body: child,
            ),
          ),
          navigatorKey: navigatorKey,
          showDebugViewButton: true,
        );
      },
    );
  }
}
