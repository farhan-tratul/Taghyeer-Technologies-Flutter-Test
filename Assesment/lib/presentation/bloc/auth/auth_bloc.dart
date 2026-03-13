import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/exceptions.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final LogoutUseCase logoutUseCase;
  final HasValidSessionUseCase hasValidSessionUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getCachedUserUseCase,
    required this.logoutUseCase,
    required this.hasValidSessionUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<CheckSessionEvent>(_onCheckSession);
    on<LogoutEvent>(_onLogout);
    on<GetCachedUserEvent>(_onGetCachedUser);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await loginUseCase(
        username: event.username,
        password: event.password,
      );
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      emit(AuthFailure(e.message));
    }
  }

  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasSession = await hasValidSessionUseCase();
      if (hasSession) {
        final user = await getCachedUserUseCase();
        if (user != null) {
          emit(SessionValid(user));
        } else {
          emit(const SessionInvalid());
        }
      } else {
        emit(const SessionInvalid());
      }
    } catch (e) {
      emit(const SessionInvalid());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await logoutUseCase();
      emit(const LogoutSuccess());
      emit(const AuthInitial());
    } on AppException catch (e) {
      emit(AuthFailure(e.message));
    }
  }

  Future<void> _onGetCachedUser(
    GetCachedUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await getCachedUserUseCase();
      if (user != null) {
        emit(AuthSuccess(user));
      }
    } catch (e) {
      emit(const AuthFailure('Failed to get cached user'));
    }
  }
}
