import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/shimmer/book_card_shimmer.dart';
import 'package:medical_app/core/shimmer/grid_shimmer.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/core/widgets/svg_pic.dart';
import 'package:medical_app/features/search/presentation/widgets/search_item.dart';
import 'package:medical_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:medical_app/features/search/presentation/cubit/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
      final searchCubit = context.read<SearchCubit>();
      final query = searchCubit.searchController.text;
      if (query.isNotEmpty) {
        searchCubit.search(query, loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: SvgPic(assetName: AppAssets.back),
        ),
      ),
      body: MyBodyView(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                hintText: "Search...",
                controller: context.read<SearchCubit>().searchController,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().searchController.clear();
                  },
                  icon: const Icon(Icons.close),
                ),
                onTap: () {},
              ),
              const Gap(15),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  var books = context.read<SearchCubit>().books;
                  if (state is SearchLoading) {
                    return GridShimmer(shimmerWidget: BookCardShimmer());
                  } else if (state is SearchError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text("No result found"),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: books.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          var book = books[index];
                          return SearchItem(item: book);
                        },
                      ),
                      if (context.watch<SearchCubit>().isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
