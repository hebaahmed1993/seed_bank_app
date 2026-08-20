String? confirmPasswordValidator(String? value, String originalPassword) {
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  if (value != originalPassword) {
    return 'كلمة المرور غير متطابقة';
  }
  return null;
}

String? newpasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  if (value.length < 6) {
    return 'يجب أن يكون طول كلمة المرور 6  على الأقل';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}
//
// String? phoneNumberValidator(String? value) {
//   value = value?.trim();
//   if (value == null || value.isEmpty) {
//     return 'هذا الحقل مطلوب';
//   }
//   if (!RegExp(r'^\d+$').hasMatch(value)) {
//     return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
//   }
//   if (value.length < 9) {
//     return 'رقم الهاتف يجب أن يحتوي على 9 أرقام على الأقل';
//   }
//   return null;
// }

String? birthYearValidator(String? value) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  if (!RegExp(r'^\d{4}$').hasMatch(value)) {
    return 'يجب أن تكون سنة الميلاد مكونة من 4 أرقام';
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  value = value?.trim();
  if (value == null || value.isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  if (!RegExp(r'^\d{9}$').hasMatch(value)) {
    return 'يجب أن يتكون رقم الهاتف من 9 أرقام فقط';
  }
  return null;
}

String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}
// 👈 أضف هذا الـ Validator الجديد مع باقي الـ Validators الموجودة لديك
String? hexColorValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال كود اللون'; // أو اربطه بالـ localization إذا كنت ت مرر الـ context
  }
  final clean = value.replaceAll('#', '').trim();
  if (clean.length != 6 || int.tryParse(clean, radix: 16) == null) {
    return 'صيغة غير صحيحة (مثال: #2196F3)';
  }
  return null;
}
String? priceValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  if (double.tryParse(value) == null) {
    return 'قيمة غير صالحة';
  }
  return null;
}

String? otpValidator(String? value) {
  if (value == null || value.length != 6) {
    return '';
  }
  return null;
}

String? otpValidatorSadad(String? value) {
  if (value == null || value.length != 5) {
    return '';
  }
  return null;
}
