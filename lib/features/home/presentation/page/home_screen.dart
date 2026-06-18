

import 'package:flutter/material.dart';
import 'package:medical_app/core/styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Container(padding: const EdgeInsets.all(20),width: double.infinity, height: 156,decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),color: AppColors.primaryColor),child:SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Hello, ",style: TextStyle(color: Colors.white,fontSize: 20),),
                    
                  ],
                ),
                
              ]
            ),
          ),),

        ],
      ),
      );
    
  }
}