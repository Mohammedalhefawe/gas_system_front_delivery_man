import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDetailsOrderPageWidget extends StatelessWidget {
  const ShimmerDetailsOrderPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        child: Column(
          children: [
            // Header Shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Info Card Shimmer
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Items Card Shimmer
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Delivery Info Shimmer
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Summary Card Shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
