import '../../../../shared/models/walk.dart';
import '../../../../core/repositories/base_repository.dart';

abstract class WalkRepository extends BaseRepository<Walk> {
  Future<List<Walk>> getWalksForUser(String userId);
  Future<List<Walk>> getRecentWalks(String userId, {int limit = 10});
  Future<void> addPhotoToWalk(String walkId, String photoUrl);
  Future<void> removePhotoFromWalk(String walkId, String photoUrl);
  Future<void> addObservationToWalk(String walkId, String observationId);
  Future<void> removeObservationFromWalk(String walkId, String observationId);
  Stream<Walk> getWalkStream(String walkId);
}
