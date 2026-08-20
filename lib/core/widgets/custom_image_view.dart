import 'package:flutter/material.dart';
import '../constants/app_images.dart';

enum ImageType {
  defaultType,
  product,
  category,
  banner,
  profile,
}

class CustomImageView extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final ImageType imageType; // 2. إضافة المتغير الجديد

  const CustomImageView({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.imageType = ImageType.defaultType, // القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    Widget imageWidget;

    if (hasValidUrl) {
      imageWidget = Image.network(
        imageUrl!.trim(),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  // 3. بناء الـ Placeholder الذكي
  Widget _buildPlaceholder() {
    IconData fallbackIcon;

    // تحديد الأيقونة المناسبة بناءً على السياق (النوع)
    switch (imageType) {
      case ImageType.product:
        fallbackIcon = Icons.shopping_bag_outlined;
        break;
      case ImageType.category:
        fallbackIcon = Icons.category_outlined;
        break;
      case ImageType.banner:
        fallbackIcon = Icons.image_outlined;
        break;
      case ImageType.profile:
        fallbackIcon = Icons.person_outline;
        break;
      case ImageType.defaultType:
      default:
      // العودة للسلوك القديم وعرض الصورة الافتراضية من الـ Assets
        return Image.asset(
          AppImages.placeholder,
          width: width,
          height: height,
          fit: fit,
        );
    }

    // رسم حاوية رمادية أنيقة تتوسطها الأيقونة المحددة
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          fallbackIcon,
          color: Colors.grey[400],
          size: 32, // يمكنك تكبيره أو تصغيره حسب الرغبة
        ),
      ),
    );
  }
}