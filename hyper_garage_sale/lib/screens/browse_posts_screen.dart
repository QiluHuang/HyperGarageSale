import 'package:flutter/material.dart';
import 'package:hypergaragesale/screens/item_detail_screen.dart';
import 'package:intl/intl.dart';

import '../model/items_repository.dart';
import '../model/items.dart';

// import Screens
import 'package:hypergaragesale/screens/login_screen.dart';
import 'package:hypergaragesale/screens/new_post_screen.dart';
import 'package:hypergaragesale/screens/browse_posts_screen.dart';
import 'package:hypergaragesale/screens/registration_screen.dart';
import 'package:hypergaragesale/model/post_data.dart';
import 'package:hypergaragesale/screens/item_detail_screen.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrowsePostsScreen extends StatefulWidget {
  static String id = 'browse_posts_screen';

  @override
  _BrowsePostsScreenState createState() => _BrowsePostsScreenState();
}

class _BrowsePostsScreenState extends State<BrowsePostsScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  /// trigger the getCurrentUser()
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  /// Check to see if there is a current user who is signed in
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        // check the method
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Action Bar
  void choiceAction<String>(String choice) {
    if (choice == Choice.addItem) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewPostScreen()));
    } else if (choice == Choice.signOut) {
      Navigator.pop(context);
    }
  }

  /// Make a collection of cards
  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,

                /// Adjust the box size
                /// The images zoom in a little and remove the extra whitespace.
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.body2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              /// Sign Out
              _auth.signOut();
              Navigator.pop(context);
            }),
        title: Text('Hyper Garage Sale'),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Choice.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: MessagesStream(),

      /// 旧body
//      body: GridView.count(
//        crossAxisCount: 2,
//        padding: EdgeInsets.all(16.0),
//        childAspectRatio: 8.0 / 9.0,
//
//        /// Multiply the card into a collection, Assign the generated cards to GridView's children field.
//        children: _buildGridCards(context),
//      ),

      bottomNavigationBar: BottomAppBar(
        /// 底部导航栏打出一个圆形的洞，BottomAppBar的shape属性决定洞的外形，CircularNotchedRectangle实现了一个圆形的外形
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.home)),
            SizedBox(),

            /// 中间位置空出
            IconButton(icon: Icon(Icons.person)),
          ],

          /// 均分底部导航栏横向空间
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
      floatingActionButton: AddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.pink[200],
      child: Icon(Icons.add),
      onPressed: () {
        _onAdd(context);
      },
    );
  }

  _onAdd(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewPostScreen()));
//    Navigator.pushNamed(context, NewPostScreen.id);

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result sucessfully')));
  }
}

class Choice {
  static String addItem = 'Add Item';
  static String signOut = 'Sign Out';

  static List<String> choices = <String>[
    addItem,
    signOut,
  ];
}

/// Get the data from firebase
class MessagesStream extends StatelessWidget {
  final List<Widget> itemList = [];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        for (var message in messages) {
          final user = message.data['user'];
          final price = message.data['price'];
          final title = message.data['title'];
          final description = message.data['description'];
          final image_path = message.data['url'];
          final item = PostData(
            user: user,
            price: price,
            title: title,
            description: description,
            imagePath: image_path,
          );
          itemList.add(
            ListTile(
              title: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AspectRatio(
                      aspectRatio: 13 / 10,
                      child: Image.network(
                        item.imagePath == null
                            ? 'images/image.png'
                            : image_path,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: theme.textTheme.title,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '\$' + item.price,
                        style: theme.textTheme.body2,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  RaisedButton(
                      child: Text('Details'),
                      elevation: 8.0,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetail(
                                      priceD: item.price,
                                      imagePathD: image_path,
                                      userD: item.user,
                                      descriptionD: item.description,
                                      titleD: item.title,
                                    )));
                      }),
                ],
              ),
            ),
          );
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: itemList,
        );
      },
    );
  }
}
