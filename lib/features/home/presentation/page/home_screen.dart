import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/image_container.dart';

import 'package:medical_app/features/home/presentation/widgets/colored_container.dart';
import 'package:medical_app/features/home/presentation/widgets/popular_grid.dart';
import 'package:medical_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:medical_app/features/home/presentation/cubit/home_state.dart';
import '../../../../core/functions/navigations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeCubit>().getPopularDoctors(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = SharedPref.getuserinfo();
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 156,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
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
                  onTap: () {
                    pushTo(context, Routes.search);
                  },
                ),
              ),
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ColoredContainer(
                  color: AppColors.purple,
                  assetName: AppAssets.dentist,
                  ontap: () {
                    pushTo(context, "${Routes.search}?q=dentist");
                  },
                ),
                ColoredContainer(
                  color: AppColors.green,
                  assetName: AppAssets.cardiology,
                  ontap: () {
                    pushTo(context, "${Routes.search}?q=cardiology");
                  },
                ),
                ColoredContainer(
                  color: AppColors.orange,
                  assetName: AppAssets.eye,
                  ontap: () {
                    pushTo(context, "${Routes.search}?q=eye");
                  },
                ),
                ColoredContainer(
                  color: AppColors.red,
                  assetName: AppAssets.fitness,
                  ontap: () {
                    pushTo(context, "${Routes.search}?q=fitness");
                  },
                ),
              ],
            ),
            const PopularGrid(),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (context.read<HomeCubit>().isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
