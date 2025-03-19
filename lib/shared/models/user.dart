import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(false) bool isGuest,
    @Default(false) bool isPremium,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? lastLoginAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

DateTime? _timestampFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _timestampToJson(DateTime? date) =>
    date != null ? Timestamp.fromDate(date) : null;
