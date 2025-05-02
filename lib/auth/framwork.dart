import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class coboutton extends StatelessWidget {

  final String text;

  final Color bgcolor;

  final Color textcolor;

  coboutton(
      {super.key, required this.text, required this.bgcolor, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,

          foregroundColor: textcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );;
  }
}


class Costmer extends StatefulWidget {
  final String? namee;
  final String? title;
  final IconData? iconn;
  final TextInputType textInputType;
  final bool isPassword;

  final TextEditingController controler;

// إضافة وسيط لنوع الإدخال

  const Costmer({
    Key? key,
    required this.iconn,
    required this.controler,
    this.namee = '',
    required this.title,
    this.textInputType = TextInputType
        .text, this.isPassword = false, // قيمة افتراضية لنوع الإدخال
  }) : super(key: key);

  @override
  State<Costmer> createState() => _CostmerState();
}

class _CostmerState extends State<Costmer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            // child: Text(
            //   "${widget.title}",
            //   style: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold),
            // ),
          ),
          Container(
            height: 70,
            child: TextFormField(
              controller: widget.controler,
              obscureText: widget.isPassword,
              keyboardType: widget.textInputType, // استخدام الوسيط هنا
              decoration: InputDecoration(

                fillColor: Colors.white,
                labelText: widget.title,
                labelStyle: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                filled: true,
                prefixIcon: Icon(
                  widget.iconn,
                  color: Colors.blue[600],
                  size: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 197, 103, 97),
                    width: 5,
                  ),
                ),
                focusColor: Colors.green[600],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> LoginUser(String email, String password) async {
  final url = Uri.parse("Api");
  try {
    final response = await http.post(url, headers: {
      "Content-Type": "application/json"
    }, body: jsonEncode({
      "email": email,
      "password": password,})
    ) ;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        print("Login Success 🎉");

        print("User Data: ${data['user']}")
        ;


        return true ;



      } else {
        print("Login Failed: ${data['message']}");
        return false ;
      }
    } else {
      print("Server Error: ${response.statusCode}");
      return false ;
    }
  } catch (error) {
    print("Error occurred: $error");
    return false  ;
  }

}
// Future<void> saveuserdata (String email , usertype) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   await prefs.setString('email', email);
//   await prefs.setString('userType', usertype);
//
//   print("Data Saved Successfully!");
// }

/////////Animation


class AnimatedHeaderText extends StatefulWidget {
  @override
  _AnimatedHeaderTextState createState() => _AnimatedHeaderTextState();
}

class _AnimatedHeaderTextState extends State<AnimatedHeaderText>
    with SingleTickerProviderStateMixin {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    // تحريك الوميض كل ثانية
    _startBlinking();
  }

  void _startBlinking() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _visible = !_visible;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: _visible ? 1.0 : 0.0,
      child: Text(
        'Start As :',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}



