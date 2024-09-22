import 'package:flutter/material.dart';
import 'package:movie_app/Pages/ProfilePage/ProfilePage.dart';


class privacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: const Text('Privacy', style: TextStyle(
            fontSize: 30,
            color: Colors.white)),
        backgroundColor: const Color.fromRGBO(1, 3, 16, 0.93),
      ),
      body: Container(
        color: const Color.fromRGBO(27, 35, 48, 1), // Dark blue background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Privacy Policy of MoveList\n\n'
                'MovieList operates the MoveListApp, which provides the SERVICE.\n\n'
                'This page is used to inform App visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service, the smartersvision.com website.\n\n'
                'If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\n'
                'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at smartersvision.com, unless otherwise defined in this Privacy Policy.',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white, // White text color for better contrast
            ),
          ),
        ),
      ),
    );
  }
}
