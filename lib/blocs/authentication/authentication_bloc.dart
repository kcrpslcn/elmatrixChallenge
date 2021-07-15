import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authentication_bloc.freezed.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationState.initial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.map(
      appStarted: (event) async* {
        try {
          final isSignedIn = await _userRepository.isAuthenticated();
          if (!isSignedIn) await _userRepository.authenticate();
          final userId = _userRepository.getUserId();
          yield userId == null ? Unauthenticated() : Authenticated(userId);
        } catch (_) {
          yield Unauthenticated();
        }
      },
    );
  }
}
