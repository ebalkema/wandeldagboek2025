import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/latlng_converter.dart';

part 'walk.freezed.dart';
part 'walk.g.dart';

@freezed
class Walk with _$Walk {
  const factory Walk({
    required String id,
    required String userId,
    required String title,
    String? description,
    @LatLngConverter() required List<LatLng> route,
    required double distance,
    required Duration duration,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0) int elevationGain,
    @Default(0) int elevationLoss,
    @Default([]) List<String> photoUrls,
    @Default([]) List<String> observationIds,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _Walk;

  factory Walk.fromJson(Map<String, dynamic> json) => _$WalkFromJson(json);
}

DateTime? _timestampFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _timestampToJson(DateTime? date) =>
    date != null ? Timestamp.fromDate(date) : null;
