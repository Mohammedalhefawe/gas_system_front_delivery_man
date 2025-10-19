import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/models/ad_model.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AdSpace extends StatelessWidget {
  final List<AdModel> ads;
  final bool isLoading;

  const AdSpace({super.key, required this.ads, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer(context);
    }
    if (ads.isEmpty) {
      return _buildEmptyAdSpace();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 220,
              autoPlay: ads.length > 1,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.9,
              enableInfiniteScroll: ads.length > 1,
              pauseAutoPlayOnTouch: true,
              scrollDirection: Axis.horizontal,
            ),
            items: ads.map((ad) => _buildAdCard(ad, context)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p16,
      ),
      child: Shimmer.fromColors(
        baseColor: ColorManager.colorDoveGray100,
        highlightColor: ColorManager.colorWhite,
        child: Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: ColorManager.colorDoveGray300,
            borderRadius: BorderRadius.circular(AppSize.s8),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAdSpace() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p16,
      ),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: ColorManager.colorGrey5,
          borderRadius: BorderRadius.circular(AppSize.s16),
          border: Border.all(color: ColorManager.colorGrey4, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_rounded,
              size: AppSize.s40,
              color: ColorManager.colorDoveGray600,
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              "NoAdsAvailable".tr,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.colorDoveGray600,
                fontWeight: FontWeight.w500,
              ),
              semanticsLabel: "NoAdsAvailable".tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard(AdModel ad, BuildContext context) {
    return Semantics(
      label: ad.title,
      hint: 'Tap to visit ${ad.link}',
      child: GestureDetector(
        onTap: () => _launchUrl(ad.link),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.colorWhite,
            borderRadius: BorderRadius.circular(AppSize.s8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s8),
            child: Stack(
              children: [
                if (ad.image != null && ad.image!.isNotEmpty)
                  _buildCachedImage(ad)
                else
                  _buildAdPlaceholder(ad),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        ColorManager.colorBlack.withOpacity(0.8),
                        ColorManager.colorBlack.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 0.8],
                    ),
                  ),
                ),
                Positioned(
                  left: AppPadding.p16,
                  right: AppPadding.p16,
                  bottom: AppPadding.p16,
                  child: _buildAdContent(ad),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCachedImage(AdModel ad) {
    return CachedNetworkImage(
      imageUrl: ad.image!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: ColorManager.colorDoveGray100,
        highlightColor: ColorManager.colorWhite,
        child: Container(color: ColorManager.colorDoveGray300),
      ),
      errorWidget: (context, url, error) => _buildAdPlaceholder(ad),
    );
  }

  Widget _buildAdPlaceholder(AdModel ad) {
    return Container(
      color: ColorManager.colorPrimary.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_rounded,
            size: AppSize.s40,
            color: ColorManager.colorPrimary,
          ),
          const SizedBox(height: AppSize.s12),
          _buildAdContent(ad),
        ],
      ),
    );
  }

  Widget _buildAdContent(AdModel ad) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ad.title,
            style: TextStyle(
              fontSize: FontSize.s18,
              fontWeight: FontWeight.w700,
              color: ColorManager.colorWhite,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: ad.title,
          ),
          const SizedBox(height: AppSize.s8),
          if (ad.description.isNotEmpty)
            Text(
              ad.description,
              style: TextStyle(
                fontSize: FontSize.s14,
                fontWeight: FontWeight.w400,
                color: ColorManager.colorWhite.withValues(alpha: 0.9),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: ad.description,
            ),
        ],
      ),
    );
  }

  void _launchUrl(String link) async {
    if (link.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'InvalidUrl'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final url = Uri.parse(link);
    Map<String, bool> urlCache = {};
    bool canLaunch = urlCache[link] ?? await canLaunchUrl(url);
    urlCache[link] = canLaunch;

    if (canLaunch) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error'.tr,
        'CannotLaunchUrl'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
