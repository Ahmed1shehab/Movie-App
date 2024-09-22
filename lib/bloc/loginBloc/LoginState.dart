import 'package:firebase_auth/firebase_auth.dart';

class LoginState {
  final bool isPasswordVisible;
  final bool isSigningIn;
  final User? user;
  final String? errorMessage;

  LoginState({
    required this.isPasswordVisible,
    required this.isSigningIn,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isPasswordVisible,
    bool? isSigningIn,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSigningIn: isSigningIn ?? this.isSigningIn,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
