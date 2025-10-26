import 'package:mocktail/mocktail.dart';
import 'package:consistify/domain/usecases/auth/register_user.dart';
import 'package:consistify/domain/usecases/auth/login_user.dart';
import 'package:consistify/domain/usecases/auth/get_user_profile.dart';
import 'package:consistify/domain/usecases/auth/update_user_profile.dart';
import 'package:consistify/domain/usecases/auth/logout_user.dart';
import 'package:consistify/domain/usecases/consistency/get_daily_consistency.dart';
import 'package:consistify/domain/usecases/consistency/get_consistency_history.dart';
import 'package:consistify/domain/usecases/consistency/get_streaks.dart';

class MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}
class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}
class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}
class MockUpdateUserProfileUseCase extends Mock implements UpdateUserProfileUseCase {}
class MockLogoutUserUseCase extends Mock implements LogoutUserUseCase {}

class MockGetDailyConsistencyUseCase extends Mock implements GetDailyConsistencyUseCase {}
class MockGetConsistencyHistoryUseCase extends Mock implements GetConsistencyHistoryUseCase {}
class MockGetStreaksUseCase extends Mock implements GetStreaksUseCase {}
