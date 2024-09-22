import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/bloc/profileBloc/profileState.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileCubit(this._auth, this._firestore, this._storage)
      : super(ProfileLoading());

  Future<void> loadUserData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc = await _firestore.collection('usersDetails')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          emit(ProfileLoaded(
            userName: userDoc['fullName'],
            email: userDoc['email'],
            imageUrl: userDoc['profileImage'],
          ));
        } else {
          emit(ProfileNotCreated()); // New state for profile not yet created
        }
      } else {
        emit(ProfileError('No user is currently signed in.'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load user data.'));
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      String filePath = 'profileImages/${currentUser.uid}.png';
      await _storage.ref(filePath).putFile(imageFile);
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();

      await _firestore.collection('usersDetails').doc(currentUser.uid).update({
        'profileImage': downloadUrl,
      });

      emit(ProfileLoaded(
        userName: currentUser.displayName ?? 'No Name',
        email: currentUser.email!,
        imageUrl: downloadUrl,
      ));
    } catch (e) {
      emit(ProfileError('Failed to upload image: $e'));
      print('Error uploading image: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        print('Image picked from gallery: ${returnedImage.path}');
        uploadImage(File(returnedImage.path));
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      emit(ProfileError('Failed to pick image from gallery.'));
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final returnedImage = await ImagePicker().pickImage(
          source: ImageSource.camera);
      if (returnedImage == null) {
        print('No image selected.');
        return;
      }
      uploadImage(File(returnedImage.path));
    } catch (e) {
      print('Error picking image from camera: $e');
      emit(ProfileError('Failed to pick image from camera.'));
    }
  }
}