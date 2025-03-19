import '../../../../shared/models/observation.dart';
import '../../../../core/repositories/base_repository.dart';

abstract class ObservationRepository extends BaseRepository<Observation> {
  Future<List<Observation>> getObservationsForWalk(String walkId);
  Future<List<Observation>> getObservationsForUser(String userId);
  Future<List<Observation>> getObservationsByType(ObservationType type);
  Future<void> addPhotoToObservation(String observationId, String photoUrl);
  Future<void> removePhotoFromObservation(
      String observationId, String photoUrl);
  Future<void> updateMetadata(
      String observationId, Map<String, dynamic> metadata);
  Stream<Observation> getObservationStream(String observationId);
}
