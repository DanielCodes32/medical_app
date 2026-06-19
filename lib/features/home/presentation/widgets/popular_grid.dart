import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/shimmer/grid_shimmer.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:medical_app/features/home/presentation/cubit/home_state.dart';
import 'package:medical_app/features/home/presentation/widgets/item.dart';

class PopularGrid extends StatelessWidget {
  const PopularGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBodyView(
      child: Column(
        children: [
          Gap(10),
          Text("Popular Doctors", style: TextStyles.title),

          BlocBuilder<HomeCubit, HomeState>(
            builder: (BuildContext context, HomeState state) {
              var homeCubit = context.read<HomeCubit>();

              if (state is LoadingHomeState || state is InitalHomeState) {
                return GridShimmer(itemCount: 6, shimmerWidget: Item());
              } else if (state is ErrorHomeState) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.message ?? "Failed to load doctors",
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // SuccessHomeState
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                shrinkWrap: true,
                itemCount: homeCubit.popularDoctors.length,
                itemBuilder: (context, index) {
                  var data = homeCubit.popularDoctors[index];
                  return Item(item: data);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
