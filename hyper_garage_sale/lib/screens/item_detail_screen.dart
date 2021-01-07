import 'package:flutter/material.dart';
import 'package:hypergaragesale/model/post_data.dart';
import 'package:hypergaragesale/model/item_detail.dart';

class ItemDetail extends StatelessWidget {
  static String id = 'item_detail_screen';

  ItemDetail(
      {this.userD,
      this.priceD,
      this.titleD,
      this.descriptionD,
      this.imagePathD});

  final String userD;
  final String titleD;
  final String priceD;
  final String descriptionD;
  final String imagePathD;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Hyper Garage Sale'),
      ),
      body: Column(
        children: <Widget>[
          Image.network(imagePathD),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                titleD,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '\$' + priceD,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'sold by   ' + userD,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 16,
          ),
          Text(descriptionD),
        ],
      ),
    );
  }
}
