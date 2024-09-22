import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String email;
  final String? imageUrl;

  ProfileLoaded({required this.userName, required this.email, this.imageUrl});

  @override
  List<Object> get props => [userName, email, imageUrl ?? ''];
}

class ProfileNotCreated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
