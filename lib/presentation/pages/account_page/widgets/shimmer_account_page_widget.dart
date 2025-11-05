import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAccountPageWidget extends StatelessWidget {
  const ShimmerAccountPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: AppSize.s16),
                // Profile Card Shimmer
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  padding: const EdgeInsets.all(AppPadding.p24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: AppSize.s60,
                            height: AppSize.s60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSize.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: AppSize.s8),
                                Container(
                                  width: 80,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s20),
                      Container(height: 1, color: Colors.white),
                      const SizedBox(height: AppSize.s16),
                      Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.s20),
                // Options Section Shimmer
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.all(AppPadding.p20),
                        child: Row(
                          children: [
                            Container(
                              width: AppSize.s40,
                              height: AppSize.s40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppSize.s16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: AppSize.s4),
                                  Container(
                                    width: 80,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: AppSize.s16,
                              height: AppSize.s16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
