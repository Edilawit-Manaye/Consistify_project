// consistify_frontend/lib/presentation/blocs/consistency/consistency_state.dart

part of 'consistency_bloc.dart';

abstract class ConsistencyState extends Equatable {
  const ConsistencyState();

  @override
  List<Object?> get props => [];
}

class ConsistencyInitial extends ConsistencyState {}

class ConsistencyLoading extends ConsistencyState {}

class ConsistencyLoaded extends ConsistencyState {
  final DailyConsistency? dailyConsistency;
  final List<DailyConsistency>? consistencyHistory;
  final StreakInfo? streakInfo;

  const ConsistencyLoaded({
    this.dailyConsistency,
    this.consistencyHistory,
    this.streakInfo,
  });

  @override
  List<Object?> get props => [dailyConsistency, consistencyHistory, streakInfo];

  ConsistencyLoaded copyWith({
    DailyConsistency? dailyConsistency,
    List<DailyConsistency>? consistencyHistory,
    StreakInfo? streakInfo,
  }) {
    return ConsistencyLoaded(
      dailyConsistency: dailyConsistency ?? this.dailyConsistency,
      consistencyHistory: consistencyHistory ?? this.consistencyHistory,
      streakInfo: streakInfo ?? this.streakInfo,
    );
  }
}

class ConsistencyError extends ConsistencyState {
  final String message;

  const ConsistencyError(this.message);

  @override
  List<Object> get props => [message];
}