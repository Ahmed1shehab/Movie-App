
// RegisterState.dart
class RegisterState {
  final bool isPasswordVisible;
  final bool isSigningUp;
  final bool? signUpSuccess;

  RegisterState({
    required this.isPasswordVisible,
    required this.isSigningUp,
    this.signUpSuccess,
  });

  RegisterState copyWith({
    bool? isPasswordVisible,
    bool? isSigningUp,
    bool? signUpSuccess,
  }) {
    return RegisterState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSigningUp: isSigningUp ?? this.isSigningUp,
      signUpSuccess: signUpSuccess,
    );
  }
}