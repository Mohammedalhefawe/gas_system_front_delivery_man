import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNotificationPageWidget extends StatelessWidget {
  const ShimmerNotificationPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSize.s8),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList.separated(
                itemCount: 3,
                itemBuilder: (context, index) =>
                    _buildShimmerNotificationItem(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSize.s8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerNotificationItem() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: Container(
        color: ColorManager.colorWhite,
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSize.s26,
                  height: AppSize.s26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Container(width: 120, height: 18, color: Colors.white),
                const Spacer(),
                Container(
                  width: AppSize.s24,
                  height: AppSize.s24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s12),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: AppSize.s16),
            Container(height: 1, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
