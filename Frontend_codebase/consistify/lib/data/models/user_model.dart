// consistify_frontend/lib/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:consistify/domain/entities/user.dart';

part 'user_model.g.dart'; 
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.notificationTime,
    required super.timezone,
    super.platformUsernames,
    super.fcmTokens,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);


}