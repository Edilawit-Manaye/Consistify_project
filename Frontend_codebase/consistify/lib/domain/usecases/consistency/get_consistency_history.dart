// consistify_frontend/lib/domain/usecases/consistency/get_consistency_history.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';

class GetConsistencyHistoryUseCase {
  final ConsistencyRepository repository;

  GetConsistencyHistoryUseCase(this.repository);

  Future<Either<Failure, List<DailyConsistency>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await repository.getConsistencyHistory(
      startDate: startDate,
      endDate: endDate,
    );
  }
}