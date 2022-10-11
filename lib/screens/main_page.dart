
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_app/screens/user_data.dart';

import 'home_screen.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text('SKILL UP AFRICA DATA CENTER'),
          centerTitle: true,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            decorationThickness: 2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'UPDATE YOUR DATA',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              Divider(
                thickness: 4,
                color: Colors.black,
              ),
              FittedBox(
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: ((context) => HomeScreen())));
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 25),
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Update Notes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            )),
                      ),
                     SizedBox(width: 20,),
                     GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: ((context) => UserData())));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 25),
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Update Datas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            )),
                      ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
