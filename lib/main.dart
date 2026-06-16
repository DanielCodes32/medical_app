import 'package:flutter/material.dart';

import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of your DatabaseService


  await SharedPref.init();
  DioProvider.init();

  runApp(MainApp());
}
