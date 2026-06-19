import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/image_container.dart';

import 'package:medical_app/core/widgets/svg_pic.dart';
import 'package:medical_app/features/home/presentation/widgets/colored_container.dart';

import 'package:medical_app/features/home/presentation/widgets/popular_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = SharedPref.getuserinfo();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: AppColors.primaryColor,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, ${user == null ? "user" : user.username} ",
                          style: TextStyles.title1,
                        ),
                        ImageContainer(
                          image: Image.asset(AppAssets.profile),
                          width: 60,
                          height: 60,
                        ),
                      ],
                    ),
                    Text(
                      "Find your doctor",
                      style: TextStyles.title.copyWith(
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {},
                child: CustomFormField(
                  hintText: "Search...",
                  readOnly: true,
                  onTap: () {},
                  
                ),
              ),
            ),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ColoredContainer(
                  color: AppColors.purple,
                  assetName: AppAssets.dentist,
                ),
                ColoredContainer(
                  color: AppColors.green,
                  assetName: AppAssets.cardiology,
                ),
                ColoredContainer(
                  color: AppColors.orange,
                  assetName: AppAssets.eye,
                ),
                ColoredContainer(
                  color: AppColors.red,
                  assetName: AppAssets.fitness,
                ),
              ],
            ),
            PopularGrid(),
          ],
        ),
      ),
    );
  }
}
