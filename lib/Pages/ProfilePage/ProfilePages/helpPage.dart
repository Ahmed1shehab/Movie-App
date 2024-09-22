import 'package:flutter/material.dart';
import 'package:movie_app/Pages/ProfilePage/ProfilePage.dart';


class helpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<helpSupportPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 3, 16, 0.93), // AppBar color
        title: Text(
          "Help & Support",
          style: TextStyle(color: Colors.white), // AppBar title color
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow color
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage()
            ),
          );

          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(27, 35, 48, 1), // Body background color
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView( // Centers the content vertically
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              children: [
                // Text field
                Container(
                  width: MediaQuery.of(context).size.width * 0.85, // Text field width
                  child: TextFormField(
                    controller: _controller,
                    maxLines: 12, // Increases the height of the text field
                    decoration: InputDecoration(
                      hintText: "Write your problem here",
                      hintStyle: TextStyle(color: Colors.white54), // Hint text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide(
                          color: Colors.blue[900]!, // Dark blue border
                          width: 2.0, // Border thickness
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white24, // Text field background color
                    ),
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
                SizedBox(height: 20),
                // Send button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50, // Smaller button height
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.clear(); // Clears the text field
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(color:  const Color.fromRGBO(1, 3, 16, 0.93),
                        fontSize: 20, // Larger text size for the button
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
