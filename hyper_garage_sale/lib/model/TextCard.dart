import 'package:flutter/material.dart';

/** Set Text, Textfield and SizedBox as a Block
 ** Column Widget = Row Widget + SizedBox Widget
 ** Row Widget = Text Widget +  TextField Widget **/

class TextCard extends StatelessWidget {
  TextCard({
    this.title,
    this.hintText,
    @required this.textIn,
    this.price,
    this.numberKeyboard,
  });

  final String title;
  final String hintText;
  final Function textIn;
  final bool price;
  final bool numberKeyboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Container(
                width: 75,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                showCursor: true,
                autofocus: true,
                keyboardType: numberKeyboard
                    ? TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  prefixIcon: price == true
                      ? Icon(Icons.attach_money, size: 17.0)
                      : null,
                ),
                onChanged: textIn,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
