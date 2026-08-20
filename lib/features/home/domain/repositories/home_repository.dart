import '../../../../core/utils/typedefs.dart';
import '../entities/home_section_entity.dart';

abstract class HomeRepository {
  ResultFuture<List<HomeSectionEntity>> getHomeSections();
}
