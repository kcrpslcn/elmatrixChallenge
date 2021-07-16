import 'package:either_dart/either.dart';
import 'package:user_repository/src/failures/authentication_failure.dart';

abstract class UserRepository {
  Future<bool> isAuthenticated();
  Future<Either<AuthenticationFailure, void>> authenticate();
  Future<void> logout();
  Either<AuthenticationFailure, String> getUserId();
}
