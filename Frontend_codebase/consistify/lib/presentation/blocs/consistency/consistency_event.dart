// consistify_frontend/lib/presentation/blocs/consistency/consistency_event.dart

part of 'consistency_bloc.dart';

abstract class ConsistencyEvent extends Equatable {
  const ConsistencyEvent();

  @override
  List<Object> get props => [];
}

class LoadConsistencyData extends ConsistencyEvent {}

class FetchDailyConsistency extends ConsistencyEvent {}

class FetchConsistencyHistory extends ConsistencyEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchConsistencyHistory({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}

class FetchStreaks extends ConsistencyEvent {}