// consistify_frontend/lib/domain/entities/consistency.dart

import 'package:equatable/equatable.dart';

class PlatformActivity extends Equatable {
  final String platform;
  final bool isConsistent;
  final int? problemsSolved;
  final DateTime? lastSolvedTime;

  const PlatformActivity({
    required this.platform,
    required this.isConsistent,
    this.problemsSolved,
    this.lastSolvedTime,
  });

  @override
  List<Object?> get props => [
    platform,
    isConsistent,
    problemsSolved,
    lastSolvedTime,
  ];
}

class DailyConsistency extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final bool overallConsistent;
  final List<PlatformActivity> platformActivities;

  const DailyConsistency({
    required this.id,
    required this.userId,
    required this.date,
    required this.overallConsistent,
    required this.platformActivities,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    overallConsistent,
    platformActivities,
  ];
}

class StreakInfo extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastConsistentDate;

  const StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    this.lastConsistentDate,
  });

  @override
  List<Object?> get props => [
    currentStreak,
    longestStreak,
    lastConsistentDate,
  ];
}