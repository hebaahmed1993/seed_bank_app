import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../domain/entities/home_section_entity.dart';

class BannerSectionWidget extends StatelessWidget {
  final BannerSectionEntity section;

  const BannerSectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    // ✨ الاستخدام الآمن للـ Enum
    switch (section.bannerStyle) {
      case BannerStyle.hero:
        return _buildHeroBanner(context, section.banners.first);
      case BannerStyle.strip:
        return _buildStripBanner(context, section.banners.first);
      case BannerStyle.slider:
        return _buildSliderBanner(context);
    }
  }

  // =====================================
  // 1. الإعلان الضخم (Hero Banner)
  // =====================================
  Widget _buildHeroBanner(BuildContext context, BannerItemEntity banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      height: 220,
      width: double.infinity,
      child: InkWell(
        onTap: () => _handleDeepLink(banner.targetUrl),
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child:


          CustomImageView(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
            imageType: ImageType.banner, // 👈 التحديد هنا
          )        ),
      ),
    );
  }

  // =====================================
  // 2. الشريط النحيف (Strip Banner)
  // =====================================
  Widget _buildStripBanner(BuildContext context, BannerItemEntity banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 80,
      width: double.infinity,
      child: InkWell(
        onTap: () => _handleDeepLink(banner.targetUrl),
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:

          CustomImageView(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
            imageType: ImageType.banner, // 👈 التحديد هنا
          )          ),
      ),
    );
  }

  // =====================================
  // 3. البانر الدوار (Slider)
  // =====================================
  Widget _buildSliderBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 160,
      child: PageView.builder(
        itemCount: section.banners.length,
        itemBuilder: (context, index) {
          final banner = section.banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () => _handleDeepLink(banner.targetUrl),
              borderRadius: BorderRadius.circular(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                CustomImageView(
                  imageUrl: banner.imageUrl,
                  fit: BoxFit.cover,
                  imageType: ImageType.banner, // 👈 التحديد هنا
                )
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة معالجة الروابط
  void _handleDeepLink(String? url) {
    if (url == null || url.isEmpty) return;
    debugPrint('Navigate to: $url');
    // TODO: كتابة منطق تحليل الروابط
  }
}
