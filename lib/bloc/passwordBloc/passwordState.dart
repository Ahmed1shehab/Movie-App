import 'package:equatable/equatable.dart';

class PasswordState extends Equatable {
  final bool isLoading;
  final String errorMessage;

  PasswordState({
    this.isLoading = false,
    this.errorMessage = '',
  });

  PasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return PasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [isLoading, errorMessage];
}
