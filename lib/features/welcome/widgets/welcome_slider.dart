import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/main_button.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/welcome/data/data.dart';

class WelcomeSlider extends StatefulWidget {
  const WelcomeSlider({super.key});

  @override
  State<WelcomeSlider> createState() => _WelcomeSliderState();
}

class _WelcomeSliderState extends State<WelcomeSlider> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final itemlist = Data.data();
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      children: [
        // Skip button at the top right
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _carouselController.jumpToPage(2);
                });
              },
              child: Text(
                "Skip",
                style: TextStyles.body1.copyWith(
                  color: AppColors.greycolor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        // Slider taking up the middle portion
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: itemlist.length,
            options: CarouselOptions(
              height: screenHeight * 0.6,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, index, realIndex) {
              final item = itemlist[index];
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Restrict image height so it fits different screen sizes nicely
                    Image.asset(
                      item.image,
                      width: double.infinity,
                      height: screenHeight * 0.35,
                      fit: BoxFit.fitWidth, // Forces it to fill the width
                    ),
                    const Gap(40),
                    MyBodyView(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            item.title,
                            style: TextStyles.headline,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          Text(
                            item.text,
                            style: TextStyles.body1.copyWith(height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom indicators and main button
        MyBodyView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            children: [
              AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: itemlist.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: AppColors.lightgrey,
                ),
                onDotClicked: (index) {
                  _carouselController.animateToPage(index);
                },
              ),
              const Gap(30),
              MainButton(
                title: _currentIndex == itemlist.length - 1
                    ? "Get Started"
                    : "Next",
                onTap: () {
                  if (_currentIndex < itemlist.length - 1) {
                    _carouselController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    pushReplacement(context, Routes.register);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
