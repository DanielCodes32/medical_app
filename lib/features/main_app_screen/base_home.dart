
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/widgets/svg_pic.dart';
import 'package:medical_app/features/home/presentation/page/home_screen.dart';

class BaseHome extends StatefulWidget {
  const BaseHome({super.key, this.currentIndex});
  final int? currentIndex;
  @override
  State<StatefulWidget> createState() {
    return _BaseHomeState();
  }
}

class _BaseHomeState extends State<BaseHome> {
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex ?? 0;
  }

 

  int selectedIndex = 0;
  final List<Widget> screens = [
    Center(
      child: HomeScreen(),

    ),
    Center(
      child: Text("favorite"),
    ),
    Center(
      child: Text("book"),
    ),
    Center(
      child: Text("message"),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
         
          child: navBar(),
        ),
      ),
    );
  }

  BottomNavigationBar navBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPic(assetName: AppAssets.home,color: AppColors.navicon),
          activeIcon: SvgPic(
            assetName: AppAssets.home,
            color: AppColors.primaryColor,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPic(assetName: AppAssets.favourite),
          activeIcon: SvgPic(
            assetName: AppAssets.favourite,
            color: AppColors.primaryColor,
          ),
          label: "bookmark",
        ),
        BottomNavigationBarItem(
          icon: SvgPic(assetName: AppAssets.book),
          activeIcon: SvgPic(
            assetName: AppAssets.book,
            color: AppColors.primaryColor,
          ),
          label: "category",
        ),
        BottomNavigationBarItem(
          icon: SvgPic(assetName: AppAssets.message),
          activeIcon: SvgPic(
            assetName: AppAssets.message,
            color: AppColors.primaryColor,
          ),
          label: "profile",
        ),
      ],
    );
  }
}
