import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOrdersPageWidget extends StatelessWidget {
  const ShimmerOrdersPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: AppSize.s8)),
          SliverList.separated(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.p20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(height: AppSize.s6),
                              Container(
                                width: 80,
                                height: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Container(width: 70, height: 28, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: AppSize.s16),
                      Row(
                        children: [
                          Container(width: 20, height: 20, color: Colors.white),
                          const SizedBox(width: AppSize.s8),
                          Container(
                            width: 200,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s16),
                      Row(
                        children: [
                          Container(width: 20, height: 20, color: Colors.white),
                          const SizedBox(width: AppSize.s8),
                          Container(
                            width: 200,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s16),
                      Container(height: 1, color: Colors.white),
                      const SizedBox(height: AppSize.s16),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSize.s8),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSize.s8),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSize.s16),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSize.s8),
                          Container(
                            width: 100,
                            height: 40,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSize.s8),
          ),
        ],
      ),
    );
  }
}
