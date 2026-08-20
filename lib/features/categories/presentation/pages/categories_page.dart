import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../providers/categories_notifier.dart';
import '../providers/categories_state.dart';
import '../widgets/categories_list_section.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // جلب الصفحة التالية عند الاقتراب من نهاية القائمة
    if (currentScroll >= maxScroll - 200) {
      ref.read(categoriesNotifierProvider.notifier).fetchMoreMainCategories();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesNotifierProvider);
    final notifier = ref.read(categoriesNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'التصنيفات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => notifier.refreshCategories(),
            tooltip: AppStrings.retry,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshCategories(),
        color: AppColors.primary,
        child: _buildBody(state, notifier),
      ),
    );
  }

  Widget _buildBody(CategoriesState state, CategoriesNotifier notifier) {
    if (state.fetchStatus == RequestStatus.loading && state.categories.isEmpty) {
      return const LoadingView(message: AppStrings.loading);
    }

    if (state.fetchStatus == RequestStatus.error && state.categories.isEmpty) {
      return ErrorView(
        message: state.errorMessage ?? AppStrings.errorOccurred,
        onRetry: () => notifier.refreshCategories(),
      );
    }

    return CategoriesListSection(
      categories: state.categories,
      isFetchingMore: state.isFetchingMore,
    );
  }
}
