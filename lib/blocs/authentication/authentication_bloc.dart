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
        yield* _appStarted();
      },
      login: (event) async* {
        yield AuthenticationState.authenticating();
        yield* _signIn();
      },
      logout: (event) async* {
        yield AuthenticationState.loggedOut();
        _userRepository.logout();
      },
    );
  }

  Stream<AuthenticationState> _appStarted() async* {
    final isAuthenticated = await _userRepository.isAuthenticated();
    yield* isAuthenticated ? _setAuthenticated() : _signIn();
  }

  Stream<AuthenticationState> _signIn() async* {
    final authenticate = await _userRepository.authenticate();
    yield* authenticate.fold((error) async* {
      yield AuthenticationState.authenticationFailed(error);
    }, (authenticated) async* {
      yield* _setAuthenticated();
    });
  }

  Stream<AuthenticationState> _setAuthenticated() async* {
    yield* _userRepository.getUserId().fold((error) async* {
      yield AuthenticationState.authenticationFailed(error);
    }, (userId) async* {
      yield AuthenticationState.authenticated(userId);
    });
  }
}
