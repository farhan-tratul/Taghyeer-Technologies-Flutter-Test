import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class CheckSessionEvent extends AuthEvent {
  const CheckSessionEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class GetCachedUserEvent extends AuthEvent {
  const GetCachedUserEvent();
}
