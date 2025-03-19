import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/latlng_converter.dart';

part 'observation.freezed.dart';
part 'observation.g.dart';

enum ObservationType { plant, animal, landscape, weather, other }

@freezed
class Observation with _$Observation {
  const factory Observation({
    required String id,
    required String walkId,
    required String userId,
    required ObservationType type,
    required String title,
    String? description,
    @LatLngConverter() required LatLng location,
    @Default([]) List<String> photoUrls,
    @Default({}) Map<String, dynamic> metadata,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime timestamp,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _Observation;

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);
}

DateTime? _timestampFromJson(Timestamp? timestamp) => timestamp?.toDate();
DateTime _requiredTimestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp? _timestampToJson(DateTime? date) =>
    date != null ? Timestamp.fromDate(date) : null;
