import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// decoration
import '../supplemental/cut_corners_border.dart';

// TextField Decoration
import 'package:hypergaragesale/supplemental/cut_corners_border.dart';

// import Screens
import 'package:hypergaragesale/screens/login_screen.dart';
import 'package:hypergaragesale/screens/new_post_screen.dart';
import 'package:hypergaragesale/screens/browse_posts_screen.dart';
import 'package:hypergaragesale/screens/registration_screen.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  /// keep it as a private property so that other classes can't accidentally mess with this variable
  final _auth = FirebaseAuth.instance;

  /// Create variables and then set them equal to the value that the user types
  String email;
  String password;

  /// Add text editing controllers, to clear the text fields' values
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  /// let the user know the app is running
  bool showSpinner = false;

  /// 邮箱正则
  final String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 检查是否是邮箱格式
  bool isEmail(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//            Container(
//              height: 200.0,
//              child: Image.asset('images/logo.png'),
//            ),
//            SizedBox(
//              height: 48.0,
//            ),

              /// Enter Email
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //TODO: something with the user input.
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: CutCornersBorder(),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),

              /// Enter password
              TextField(
                obscureText: true,
                onChanged: (value) {
                  // TODO: something with the user input.
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: CutCornersBorder(),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RaisedButton(
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 18.0),
                ),
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    // this is an asynchronous method
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      /// Back to login screen
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),

              /// Clear the text fields' values
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.blue),
                ),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  _usernameController.clear();
                  _passwordController.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
