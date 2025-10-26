

part of 'consistency_model.dart';
***********************************************************************

PlatformActivityModel _$PlatformActivityModelFromJson(
        Map<String, dynamic> json) =>
    PlatformActivityModel(
      platform: json['platform'] as String,
      username: json['username'] as String,
      date: DateTime.parse(json['date'] as String),
      problemsSolved: (json['problemsSolved'] as num).toInt(),
      isConsistent: json['isConsistent'] as bool,
    );

Map<String, dynamic> _$PlatformActivityModelToJson(
        PlatformActivityModel instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'username': instance.username,
      'date': instance.date.toIso8601String(),
      'problemsSolved': instance.problemsSolved,
      'isConsistent': instance.isConsistent,
    };

DailyConsistencyModel _$DailyConsistencyModelFromJson(
        Map<String, dynamic> json) =>
    DailyConsistencyModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      platformActivities: (json['platformActivities'] as List<dynamic>)
          .map((e) => PlatformActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallConsistent: json['overallConsistent'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DailyConsistencyModelToJson(
        DailyConsistencyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'platformActivities': instance.platformActivities,
      'overallConsistent': instance.overallConsistent,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

StreakInfoModel _$StreakInfoModelFromJson(Map<String, dynamic> json) =>
    StreakInfoModel(
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastConsistentDay: json['lastConsistentDay'] == null
          ? null
          : DateTime.parse(json['lastConsistentDay'] as String),
    );

Map<String, dynamic> _$StreakInfoModelToJson(StreakInfoModel instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastConsistentDay': instance.lastConsistentDay?.toIso8601String(),
    };
