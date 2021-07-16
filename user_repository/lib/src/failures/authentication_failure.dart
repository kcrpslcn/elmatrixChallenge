import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_failure.freezed.dart';

@freezed
class AuthenticationFailure with _$AuthenticationFailure {
  const factory AuthenticationFailure.firebaseOperationNotAllowed(String name) =
      FirebaseOperationNotAllowed;
  const factory AuthenticationFailure.notLoggedIn() = NotLoggedIn;
  const factory AuthenticationFailure.unknownError(Object? error) =
      UnknownError;
}
