// import 'package:flutter/material.dart';
//
// import '../constants/app_colors.dart';
//
// class CustomSnackBar {
//   static void _show({
//     required BuildContext context,
//     required String message,
//     required Color backgroundColor,
//     required IconData icon,
//   }) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 24.sp),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.all(24.w),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         duration: const Duration(seconds: 3),
//         elevation: 6,
//       ),
//     );
//   }
//
//   static void showSuccess({
//     required BuildContext context,
//     required String message,
//   }) {
//     _show(
//       context: context,
//       message: message,
//       backgroundColor: AppColors.success,
//       icon: Icons.check_circle_outline,
//     );
//   }
//
//   // ==========================================
//   // 🔴 دالة إظهار رسالة الخطأ
//   // ==========================================
//   static void showError({
//     required BuildContext context,
//     required String message,
//   }) {
//     _show(
//       context: context,
//       message: message,
//       backgroundColor: AppColors.error,
//       icon: Icons.error_outline,
//     );
//   }
//
//
//   static void showInfo({
//     required BuildContext context,
//     required String message,
//   }) {
//     _show(
//       context: context,
//       message: message,
//       backgroundColor: AppColors.info,
//       icon: Icons.info_outline,
//     );
//   }
// }