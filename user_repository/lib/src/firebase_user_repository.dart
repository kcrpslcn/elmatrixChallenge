import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<Either<AuthenticationFailure, void>> authenticate() async {
    try {
      return Right(await _firebaseAuth.signInAnonymously());
    } on FirebaseAuthException catch (_) {
      return Left(AuthenticationFailure.firebaseOperationNotAllowed(
          'signInAnonymously'));
    } catch (error) {
      return Left(AuthenticationFailure.unknownError(error));
    }
  }

  Either<AuthenticationFailure, String> getUserId() {
    final user = _firebaseAuth.currentUser;
    return user == null
        ? Left(AuthenticationFailure.notLoggedIn())
        : Right(user.uid);
  }

  Future<void> logout() async {
    return _firebaseAuth.signOut();
  }
}
