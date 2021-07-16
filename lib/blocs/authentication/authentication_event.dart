part of 'authentication_bloc.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.appStarted() = AppStarted;
  const factory AuthenticationEvent.login() = Login;
  const factory AuthenticationEvent.logout() = Logout;
}
