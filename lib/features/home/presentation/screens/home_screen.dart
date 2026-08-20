import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../providers/home_notifier.dart';
import '../providers/home_state.dart';
import '../widgets/home_section_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeNotifierProvider.notifier).getHomeSections();
        },
        child: _buildBody(context, ref, homeState),

    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, HomeState homeState) {
    switch (homeState.fetchStatus) {
      case RequestStatus.initial:
      case RequestStatus.loading:
        return const LoadingView();

      case RequestStatus.error:
        return ErrorView(
          message: homeState.errorMessage ?? AppStrings.errorOccurred,
          onRetry: () => ref.read(homeNotifierProvider.notifier).getHomeSections(),
        );

      case RequestStatus.success:
        final sections = homeState.sections;
        if (sections.isEmpty) {
          return Center(
            child: Text(
              AppStrings.emptyData,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return HomeSectionItem(section: sections[index]);
          },
        );
    }
  }
}
