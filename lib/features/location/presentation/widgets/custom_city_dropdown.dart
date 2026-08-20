import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/widgets/custom_dropdown_form_field.dart';
import '../providers/location_providers.dart';

class CustomCityDropdown extends ConsumerWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomCityDropdown({
    super.key,
    required this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationNotifierProvider);

    final isLoading = state.fetchCitiesStatus == RequestStatus.loading;
    final isError = state.fetchCitiesStatus == RequestStatus.error;

    List<DropdownMenuItem<String>> items = [];

    // 1. معالجة حالة التحميل
    if (isLoading && state.cities.isEmpty) {
      items = [
        const DropdownMenuItem<String>(
          value: 'loading',
          enabled: false,
          child: Text('جاري تحميل المدن...'),
        )
      ];
    }
    // 2. معالجة حالة الخطأ
    else if (isError && state.cities.isEmpty) {
      items = [
        const DropdownMenuItem<String>(
          value: 'error',
          enabled: false,
          child: Text('حدث خطأ في الجلب', style: TextStyle(color: Colors.red)),
        )
      ];
    }
    // 3. معالجة حالة عدم وجود مدن مفعلة
    else if (state.cities.isEmpty) {
      items = [
        const DropdownMenuItem<String>(
          value: 'empty',
          enabled: false,
          child: Text('لا توجد مدن متاحة حالياً'),
        )
      ];
    }
    // 4. حالة النجاح: تحويل كيان المدينة إلى عنصر قائمة
    else {
      items = state.cities.map((city) {
        return DropdownMenuItem<String>(
          value: city.cityId, // تأكدي أن المتغير اسمه cityId في CityEntity
          child: Text(city.name),
        );
      }).toList();
    }

    // 🛡️ حماية (Safety Check): تفادي خطأ Assertion إذا كانت القيمة المحفوظة غير موجودة في القائمة
    final bool isValueValid = items.any((item) => item.value == value);

    return CustomDropdownFormField<String>(
      labelText: 'المدينة',
      prefixIcon: const Icon(Icons.location_city_outlined),
      // إذا لم تكن القيمة صالحة (أو أثناء التحميل)، اجعلها null
      value: isValueValid ? value : null,
      items: items,
      // تعطيل القائمة (جعلها غير قابلة للنقر) إذا كنا في حالة تحميل أو خطأ أو فارغة
      onChanged: (isLoading || isError || state.cities.isEmpty) ? null : onChanged,
      validator: validator,
    );
  }
}