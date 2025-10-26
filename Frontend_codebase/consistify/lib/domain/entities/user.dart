// consistify_frontend/lib/domain/entities/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String notificationTime;
  final String timezone;
  final Map<String, String>? platformUsernames; 
  final List<String>? fcmTokens; 
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.notificationTime,
    required this.timezone,
    this.platformUsernames,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    notificationTime,
    timezone,
    platformUsernames,
    fcmTokens,
    createdAt,
    updatedAt,
  ];

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? notificationTime,
    String? timezone,
    Map<String, String>? platformUsernames,
    List<String>? fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      notificationTime: notificationTime ?? this.notificationTime,
      timezone: timezone ?? this.timezone,
      platformUsernames: platformUsernames ?? this.platformUsernames,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}