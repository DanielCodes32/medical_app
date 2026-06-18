import 'package:flutter/material.dart';
import 'package:medical_app/features/welcome/widgets/welcome_slider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(child: WelcomeSlider()),
    );
  }
}
