


// lib/data/models/consistency_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:consistify/domain/entities/consistency.dart'; 

part 'consistency_model.g.dart';

@JsonSerializable()
class PlatformActivityModel extends Equatable {
  final String platform;
  final String username;
  final DateTime date;
  final int problemsSolved;
  final bool isConsistent;

  const PlatformActivityModel({
    required this.platform,
    required this.username,
    required this.date,
    required this.problemsSolved,
    required this.isConsistent,
  });

  factory PlatformActivityModel.fromJson(Map<String, dynamic> json) => _$PlatformActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlatformActivityModelToJson(this);

  @override
  List<Object?> get props => [
    platform,
    username,
    date,
    problemsSolved,
    isConsistent,
  ];

  PlatformActivity toEntity() {
    return PlatformActivity(
      platform: platform,
      isConsistent: isConsistent,
      problemsSolved: problemsSolved,
      lastSolvedTime: null, 
    );
  }
}

@JsonSerializable()
class DailyConsistencyModel extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final List<PlatformActivityModel> platformActivities;
  final bool overallConsistent;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyConsistencyModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.platformActivities,
    required this.overallConsistent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyConsistencyModel.fromJson(Map<String, dynamic> json) => _$DailyConsistencyModelFromJson(json);
  Map<String, dynamic> toJson() => _$DailyConsistencyModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    platformActivities,
    overallConsistent,
    createdAt,
    updatedAt,
  ];

  DailyConsistency toEntity() {
    return DailyConsistency(
      id: id,
      userId: userId,
      date: date,
      overallConsistent: overallConsistent,
      platformActivities: platformActivities.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class StreakInfoModel extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastConsistentDay;

  const StreakInfoModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastConsistentDay,
  });

  factory StreakInfoModel.fromJson(Map<String, dynamic> json) => _$StreakInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$StreakInfoModelToJson(this);

  @override
  List<Object?> get props => [
    currentStreak,
    longestStreak,
    lastConsistentDay,
  ];

  StreakInfo toEntity() {
    return StreakInfo(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastConsistentDate: lastConsistentDay,
    );
  }
}