import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/components/submit_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/txt_form_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) :super(key:key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  CollectionReference _reference=FirebaseFirestore.instance.collection('images');

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _nameController.text = currentUser?.displayName ?? '';
    _emailController.text = currentUser?.email ?? '';
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 3, 16, 0.93),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(27, 35, 48, 1),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Stack(
              clipBehavior: Clip.none, // Ensure the button can overflow the stack
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/M64.png'),
                ),
                Positioned(
                  bottom: 0,
                  left: 0, // Position at the bottom left
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(1, 3, 16, 0.93),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Color.fromRGBO(1, 3, 16, 0.93),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.photo_library, color: Colors.white),
                                    title: Text('Pick image from gallery', style: TextStyle(color: Colors.white)),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt, color: Colors.white),
                                    title: Text('Pick image from camera', style: TextStyle(color: Colors.white)),
                                    onTap: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                                      print('${file?.path}');
                                      if (file == null) return;

                                      String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

                                      Reference referenceRoot = FirebaseStorage.instance.ref();
                                      Reference referenceDirImages = referenceRoot.child('images');
                                      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                                      try {
                                        await referenceImageToUpload.putFile(File(file.path));
                                        imageUrl = await referenceImageToUpload.getDownloadURL();
                                      } catch (error) {
                                        print(error);
                                      }
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => SettingsPage()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 60), // Adjust this value to position the button below the CircleAvatar
                    child: MaterialButton(
                      color: Color.fromRGBO(1, 3, 16, 0.93),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minWidth: 200, // Adjust width as needed
                      height: 50, // Adjust height as needed
                      child: Text(
                        'Update Photo',
                        style: TextStyle(color: Colors.white, fontSize: 18), // Adjust font size as needed
                      ),
                      onPressed: () async{
                        if(imageUrl.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('upload an image')));
                        }
                        if(key.currentState!.validate())
                          {
                              Map<String,String> dataToSend={
                                'image': imageUrl,

                              };
                              _reference.add(dataToSend);
                          }


                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            txtformfield(
              text: 'Full Name',
              icon: Icons.person,
              controller: _nameController,
            ),
            SizedBox(height: 20),
            txtformfield(
              text: 'E-mail',
              icon: Icons.email,
              controller: _emailController,
            ),
            SizedBox(height: 20),
            txtformfield(
              text: 'Current Password',
              icon: Icons.lock,
              controller: _passwordController,
            ),
            SizedBox(height: 40),
            buildActionButton(
              context: context,
              text: 'Submit Changes',
              onTap: () async {
                await _submitChanges();
              },
            ),
            SizedBox(height: 40),
            buildActionButton(
              context: context,
              text: "Delete Account",
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitChanges() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final newName = _nameController.text;
    final newEmail = _emailController.text;
    final currentPassword = _passwordController.text;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in.')));
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      await currentUser.reauthenticateWithCredential(credential);

      await currentUser.verifyBeforeUpdateEmail(newEmail);

      final userDoc = FirebaseFirestore.instance.collection('UserDetails').doc(currentUser.uid);
      await userDoc.update({
        'userName': newName,
        'email': newEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changes submitted successfully.')));
      Navigator.pushReplacementNamed(context, '/profilePage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit changes: ${e.toString()}')));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(1, 3, 16, 0.93),
          title: Text(
            "Are you sure you want to DELETE YOUR ACCOUNT?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text("No", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes", style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Handle account deletion here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
