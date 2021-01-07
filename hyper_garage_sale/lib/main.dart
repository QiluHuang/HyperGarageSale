import 'package:flutter/material.dart';

// import Screens
import 'package:hypergaragesale/screens/login_screen.dart';
import 'package:hypergaragesale/screens/new_post_screen.dart';
import 'package:hypergaragesale/screens/browse_posts_screen.dart';
import 'package:hypergaragesale/screens/registration_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red[100],
        ),

        ///添加切换页面的路径
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          BrowsePostsScreen.id: (context) => BrowsePostsScreen(),
          NewPostScreen.id: (context) => NewPostScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
        });
  }
}
