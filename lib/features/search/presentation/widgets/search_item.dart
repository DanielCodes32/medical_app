import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';

class SearchItem extends StatelessWidget {
  final Datum? item;
  final VoidCallback? onBookTap;

  const SearchItem({super.key, this.item, this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item?.id != null) {
          pushTo(context, Routes.doctorDetails, extra: item!.id.toString());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 85,
                  height: 85,
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
              const Gap(14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. ${item?.firstname ?? "Doctor"} ${item?.lastname ?? ""}",
                      style: TextStyles.title.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(3),
                    Text(
                      item?.specialization ?? "General Practice",
                      style: TextStyles.caption2.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          "${item?.totalappointments ?? 0} Appointments",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.lightgrey,
                          ),
                        ),
                        Text(
                          "Score: ${item?.score ?? 0.0}%",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                          ),
                        ),
                      ],
                    ),
                    const Gap(6),

                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          "Price: \$${item?.price ?? 250.0}",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.bodycolor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: AppColors.redcolor,
                  size: 24,
                ),
              ),
            ],
          ),
          const Gap(12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rating",
                    style: TextStyles.caption2.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: item?.averagerating ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 1.0,
                        ),
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {},
                      ),
                      const Gap(4),
                      Text(
                        "${item?.averagerating ?? 0.0}",
                        style: TextStyles.caption2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              GestureDetector(
                onTap: onBookTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Book Now",
                    style: TextStyles.button.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      )
    );
  }
}
    
  


  

