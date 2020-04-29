import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FruitDetail extends StatefulWidget {
  @override
  _FruitDetailState createState() => _FruitDetailState();
}

class _FruitDetailState extends State<FruitDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),

        child: ListView(
          children: <Widget>[
            Divider(),
            Container(height: 15.0),
            ListTile(
              title: Text(
                "Dark Theme",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Switch(
                value: Provider.of<LearnAFruitProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                  }
                },
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
