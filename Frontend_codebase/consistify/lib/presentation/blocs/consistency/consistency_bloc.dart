// consistify_frontend/lib/presentation/blocs/consistency/consistency_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/domain/usecases/consistency/get_daily_consistency.dart';
import 'package:consistify/domain/usecases/consistency/get_consistency_history.dart';
import 'package:consistify/domain/usecases/consistency/get_streaks.dart';

part 'consistency_event.dart';
part 'consistency_state.dart';

class ConsistencyBloc extends Bloc<ConsistencyEvent, ConsistencyState> {
  final GetDailyConsistencyUseCase getDailyConsistency;
  final GetConsistencyHistoryUseCase getConsistencyHistory;
  final GetStreaksUseCase getStreaks;

  ConsistencyBloc({
    required this.getDailyConsistency,
    required this.getConsistencyHistory,
    required this.getStreaks,
  }) : super(ConsistencyInitial()) {
    on<LoadConsistencyData>(_onLoadConsistencyData);
    on<FetchDailyConsistency>(_onFetchDailyConsistency);
    on<FetchConsistencyHistory>(_onFetchConsistencyHistory);
    on<FetchStreaks>(_onFetchStreaks);
  }

  Future<void> _onLoadConsistencyData(LoadConsistencyData event, Emitter<ConsistencyState> emit) async {
    emit(ConsistencyLoading());
    // Fetch all data concurrently
    final dailyConsistencyResult = await getDailyConsistency();
    final streakInfoResult = await getStreaks();

    DailyConsistency? daily;
    StreakInfo? streak;
    String? errorMessage;

    dailyConsistencyResult.fold(
          (failure) => errorMessage = _mapFailureToMessage(failure),
          (data) => daily = data,
    );
    streakInfoResult.fold(
          (failure) => errorMessage = _mapFailureToMessage(failure),
          (data) => streak = data,
    );

    if (errorMessage != null) {
      emit(ConsistencyError(errorMessage!));
    } else {
      emit(ConsistencyLoaded(
        dailyConsistency: daily,
        streakInfo: streak,
        consistencyHistory: const [], 
      ));
    }
  }

  Future<void> _onFetchDailyConsistency(FetchDailyConsistency event, Emitter<ConsistencyState> emit) async {
    
    if (state is! ConsistencyLoading) {
      emit(ConsistencyLoading());
    }

    final result = await getDailyConsistency();
    result.fold(
          (failure) => emit(ConsistencyError(_mapFailureToMessage(failure))),
          (dailyConsistency) {
        if (state is ConsistencyLoaded) {
          final currentState = state as ConsistencyLoaded;
          emit(currentState.copyWith(dailyConsistency: dailyConsistency));
        } else {
          emit(ConsistencyLoaded(dailyConsistency: dailyConsistency));
        }
      },
    );
  }

  Future<void> _onFetchConsistencyHistory(FetchConsistencyHistory event, Emitter<ConsistencyState> emit) async {
    
    if (state is! ConsistencyLoading) {
      emit(ConsistencyLoading());
    }

    final result = await getConsistencyHistory(startDate: event.startDate, endDate: event.endDate);
    result.fold(
          (failure) => emit(ConsistencyError(_mapFailureToMessage(failure))),
          (history) {
        if (state is ConsistencyLoaded) {
          final currentState = state as ConsistencyLoaded;
          emit(currentState.copyWith(consistencyHistory: history));
        } else {
          emit(ConsistencyLoaded(consistencyHistory: history));
        }
      },
    );
  }

  Future<void> _onFetchStreaks(FetchStreaks event, Emitter<ConsistencyState> emit) async {
   
    if (state is! ConsistencyLoading) {
      emit(ConsistencyLoading());
    }

    final result = await getStreaks();
    result.fold(
          (failure) => emit(ConsistencyError(_mapFailureToMessage(failure))),
          (streakInfo) {
        if (state is ConsistencyLoaded) {
          final currentState = state as ConsistencyLoaded;
          emit(currentState.copyWith(streakInfo: streakInfo));
        } else {
          emit(ConsistencyLoaded(streakInfo: streakInfo));
        }
      },
    );
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return failure.message;
      case InvalidCredentialsFailure:
        return failure.message;
      case UserNotFoundFailure:
        return failure.message;
      default:
        return 'Unexpected Error';
    }
  }
}