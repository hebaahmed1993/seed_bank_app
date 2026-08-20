import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../providers/location_providers.dart';

class CustomRegionDropdown extends ConsumerWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String labelText;

  const CustomRegionDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.validator,
    this.labelText = 'المنطقة / الحي',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationNotifierProvider);
    final isLoading = state.fetchRegionsStatus == RequestStatus.loading;
    final isDisabled = state.regions.isEmpty && !isLoading;

    if (isLoading) {
      return DropdownButtonFormField<String>(
        items: const [],
        onChanged: null,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: const Icon(Icons.map_outlined),
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          border: const OutlineInputBorder(),
        ),
        hint: const Text('جاري تحميل المناطق...'),
      );
    }

    return DropdownButtonFormField<String>(
      value: (value != null && state.regions.any((r) => r.regionId == value))
          ? value
          : null,
      onChanged: isDisabled ? null : onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.map_outlined),
        border: const OutlineInputBorder(),
      ),
      items: state.regions.map((region) {
        return DropdownMenuItem<String>(
          value: region.regionId,
          child: Text(
            '${region.name} (${region.baseFee} د.ل)',
          ),
        );
      }).toList(),
      hint: Text(
        isDisabled ? 'اختر المدينة أولاً' : 'اختر المنطقة',
      ),
    );
  }
}
