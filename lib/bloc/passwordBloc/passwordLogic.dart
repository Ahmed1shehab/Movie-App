import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/bloc/passwordBloc/passwordState.dart';

class PasswordLogic extends Cubit<PasswordState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PasswordLogic(this._auth, this._firestore) : super(PasswordState());

  Future<void> changePassword(
      String currentPassword, String newPassword, String confirmPassword) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final user = _auth.currentUser;

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
          errorMessage: 'New passwords do not match', isLoading: false));
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );

      await user!.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      await _firestore.collection('usersDetails').doc(user.uid).update({
        'password': newPassword,
      });

      emit(state.copyWith(
          errorMessage: 'Password updated successfully', isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
