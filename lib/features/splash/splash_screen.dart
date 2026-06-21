import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/core/styles/text_styles.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      if (SharedPref.gettoken() != "") {
        pushReplacement(context, Routes.home);
      } else {
        pushReplacement(context, Routes.welcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AppAssets.splash),
            Gap(11),
            Text("Doctor Hunt", style: TextStyles.title),
          ],
        ),
      ),
    );
  }
}
