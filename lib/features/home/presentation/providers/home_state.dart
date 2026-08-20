import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/home_section_entity.dart';

class HomeState {
  final RequestStatus fetchStatus;
  final List<HomeSectionEntity> sections;
  final String? errorMessage;

  const HomeState({
    this.fetchStatus = RequestStatus.initial,
    this.sections = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    RequestStatus? fetchStatus,
    List<HomeSectionEntity>? sections,
    String? errorMessage,
  }) {
    return HomeState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      sections: sections ?? this.sections,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          fetchStatus == other.fetchStatus &&
          sections == other.sections &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      fetchStatus.hashCode ^ sections.hashCode ^ errorMessage.hashCode;
}
