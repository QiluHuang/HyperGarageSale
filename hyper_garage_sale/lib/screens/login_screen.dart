import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utilities/colors.dart';
import '../supplemental/cut_corners_border.dart';

// import Screens
import 'package:hypergaragesale/screens/login_screen.dart';
import 'package:hypergaragesale/screens/new_post_screen.dart';
import 'package:hypergaragesale/screens/browse_posts_screen.dart';
import 'package:hypergaragesale/screens/registration_screen.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// keep it as a private property so that other classes can't accidentally mess with this variable
  final _auth = FirebaseAuth.instance;

  /// Create variables and then set them equal to the value that the user types
  String email;
  String password;

  /// let the user know the app is running
  bool showSpinner = false;

  /// Add text editing controllers, to clear the text fields' values
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 100.0),

              /// 图标+文字
              Column(
                children: <Widget>[
                  Image.asset('images/login_images/garage_sale_3.png'),
                  SizedBox(height: 16.0),
                  Text('Hyper Garage Sale',
                      style: Theme.of(context).textTheme.headline)
                ],
              ),
              SizedBox(
                height: 16.0,
              ),

              /// Username输入框
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // TODO: Do something with the user input
                  email = value;
                },
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',

                  /// Decorate the inputs
                  border: CutCornersBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              /// Password输入框
              TextField(
                onChanged: (value) {
                  // TODO: Do something with the user input
                  password = value;
                },
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  border: CutCornersBorder(),
                ),
                obscureText: true,
              ),

              /// Buttons按钮行
              ButtonBar(
                children: <Widget>[
                  /// Clear the text fields' values
                  FlatButton(
                    child: Text('CANCEL'),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      _usernameController.clear();
                      _passwordController.clear();
                    },
                  ),

                  /// Register Button
                  FlatButton(
                    child: Text('REGISTER'),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      // TODO: Navigate to registration screen
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                  RaisedButton(
                    child: Text('SIGN IN'),
                    elevation: 8.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        /// navigate from login_screen to browse_posts_screen
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, BrowsePostsScreen.id);
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
