part of 'authentication_bloc.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = Initial;
  const factory AuthenticationState.authenticating() = Authenticating;
  const factory AuthenticationState.authenticated(String userId) =
      Authenticated;
  const factory AuthenticationState.unauthenticated() = Unauthenticated;
  const factory AuthenticationState.authenticationFailed(
      AuthenticationFailure failure) = AuthenticationFailed;
}
