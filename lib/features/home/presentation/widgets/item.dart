import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';

class Item extends StatelessWidget {
  final Datum? item;
  const Item({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                color: AppColors.imagecolor,
                child: CachedNetworkImage(
                  imageUrl: item?.imageurl ?? "",
                  errorWidget: (context, url, error) => Image.asset(
                    AppAssets.profile,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Info section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${item?.firstname ?? "Doctor"} ${item?.lastname ?? ""}",
                    style: TextStyles.title1.copyWith(
                      fontSize: 15,
                      color: AppColors.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(3),
                  Text(
                    item?.specialization ?? "undifined",
                    style: TextStyles.caption2.copyWith(
                      color: AppColors.greycolor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(6),
                  RatingBar.builder(
                    initialRating: item?.averagerating ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
