import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pageone extends StatefulWidget {
  const Pageone({super.key});

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              "images/welcom2.jpg",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.lightGreen],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    "Welcom to my aplication",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black),
                      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('page two');
                        },
                        child: Row(
                          children: [
                            Text(
                              "Next",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            Icon(
                              Icons.keyboard_double_arrow_right_outlined,
                              color: Colors.white,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
