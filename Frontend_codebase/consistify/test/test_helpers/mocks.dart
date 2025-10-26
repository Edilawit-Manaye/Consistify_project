import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:consistify/data/datasources/auth_remote_datasource.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';
import 'package:consistify/data/datasources/consistency_remote_datasource.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';
import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/blocs/consistency/consistency_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockConsistencyRemoteDataSource extends Mock implements ConsistencyRemoteDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockConsistencyRepository extends Mock implements ConsistencyRepository {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockConsistencyBloc extends Mock implements ConsistencyBloc {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void registerFallbacks() {
  registerFallbackValue(const RegisterEvent(
    email: 'a@a.com',
    password: '12345678',
    confirmPassword: '12345678',
    username: 'user',
    notificationTime: '18:00',
  ));
  registerFallbackValue(const LoginEvent(email: 'a@a.com', password: '12345678'));
  registerFallbackValue(LogoutEvent());
}

