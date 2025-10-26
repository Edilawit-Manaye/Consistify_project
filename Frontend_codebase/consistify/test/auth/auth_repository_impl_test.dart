import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:consistify/core/errors/exceptions.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/data/repositories/auth_repository_impl.dart';
import 'package:consistify/data/datasources/auth_remote_datasource.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';

import '../test_helpers/mocks.dart';

void main() {
  late AuthRemoteDataSource remote;
  late AuthLocalDataSource local;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    local = MockAuthLocalDataSource();
    repo = AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  group('loginUser', () {
    test('returns Right(unit) and caches token on success', () async {
      when(() => remote.loginUser(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => 'jwt-token');
      when(() => local.cacheAuthToken('jwt-token')).thenAnswer((_) async {});
      when(() => local.cacheLoggedInStatus(true)).thenAnswer((_) async {});

      final result = await repo.loginUser(email: 'a@a.com', password: 'pass12345');

      expect(result, const Right(unit));
      verify(() => local.cacheAuthToken('jwt-token')).called(1);
      verify(() => local.cacheLoggedInStatus(true)).called(1);
    });

    test('returns InvalidCredentialsFailure on InvalidCredentialsException', () async {
      when(() => remote.loginUser(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const InvalidCredentialsException('bad creds'));

      final result = await repo.loginUser(email: 'a@a.com', password: 'bad');

      expect(result, isA<Left<Failure, dynamic>>());
      expect(result.swap().getOrElse(() => const ServerFailure('')), isA<InvalidCredentialsFailure>());
    });
  });

  group('getUserProfile', () {
    test('returns InvalidCredentialsFailure when no token cached', () async {
      when(() => local.getAuthToken()).thenAnswer((_) async => null);

      final result = await repo.getUserProfile();
      expect(result, isA<Left<Failure, dynamic>>());
      expect(result.swap().getOrElse(() => const ServerFailure('')), isA<InvalidCredentialsFailure>());
    });
  });
}

