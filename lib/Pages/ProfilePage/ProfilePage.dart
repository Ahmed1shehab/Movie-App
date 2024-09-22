import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../bloc/profileBloc/profileLogic.dart';
import '../../bloc/profileBloc/profileState.dart';
import '../../components/custom_icon_button.dart';
import '../../components/profile_menu_btn.dart';
import '../FavPage/Favourites.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Search/Search.dart';
import 'ProfilePages/SettingsPage.dart';
import 'ProfilePages/helpPage.dart';
import 'ProfilePages/passwordPage.dart';
import 'ProfilePages/privacyPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
        FirebaseStorage.instance,
      )..loadUserData(),
      child: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  void _showImageSourceActionSheet(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>(); // Access ProfileCubit here

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () {
                Navigator.of(context).pop();
                profileCubit.pickImageFromCamera(); // Use profileCubit directly
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                profileCubit.pickImageFromGallery(); // Use profileCubit directly
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(27, 35, 48, 0),
      ),
      backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      body: Container(
        color: const Color.fromRGBO(27, 35, 48, 1),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: state.imageUrl != null
                            ? NetworkImage(state.imageUrl!)
                            : AssetImage('assets/images/default_profile_image.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: -11,
                        right: -8,
                        child: IconButton(
                          onPressed: () => _showImageSourceActionSheet(context),
                          icon: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    state.userName,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    state.email,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 30),
                  profileBtn(text: "Privacy", event: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => privacyPolicyPage()),
                    );
                  }, icon: Icons.privacy_tip),
                  SizedBox(height: 20),
                  profileBtn(text: 'Help & Support', event: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => helpSupportPage()),
                    );
                  }, icon: Icons.help),
                  SizedBox(height: 20),
                  profileBtn(text: 'Change Password', event: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  }, icon: Icons.settings),
                  SizedBox(height: 20),
                  profileBtn(text: 'Logout', event: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/Main');
                  }, icon: Icons.logout),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.white)));
            } else {
              return Center(child: Text('Unknown state', style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(12, 16, 22, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomIconButton(
              icon: Icons.home,
              color: Colors.white,
              size: 30,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                      return FadeTransition(opacity: opacityAnimation, child: child);
                    },
                  ),
                );
              },
            ),
            CustomIconButton(
              icon: Icons.search,
              color: Colors.white,
              size: 30,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const Search(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                      return FadeTransition(opacity: opacityAnimation, child: child);
                    },
                  ),
                );
              },
            ),
            CustomIconButton(
              icon: Icons.favorite_border,
              color: Colors.white,
              size: 30,
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const FavouritesPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end);
                      var opacityAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

                      return FadeTransition(opacity: opacityAnimation, child: child);
                    },
                  ),
                );
              },
            ),
            CustomIconButton(
              icon: Icons.person_outline,
              color: Colors.white,
              size: 30,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var opacityAnimation = animation.drive(CurveTween(curve: Curves.easeInOut));
                      return FadeTransition(opacity: opacityAnimation, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
