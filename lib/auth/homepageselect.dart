import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'framwork.dart';

class HomePageSelect extends StatefulWidget {
  const HomePageSelect({super.key});

  @override
  State<HomePageSelect> createState() => _HomePageSelectState();
}

class _HomePageSelectState extends State<HomePageSelect> {

  Future<void> saveAccountType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountType', type);
  }
  Future<String?> getAccountType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accountType');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1000,
            width: 500,
            decoration: BoxDecoration(color: Colors.lightGreen),

          ),
          Container(
            color: Colors.lightGreen,

          ),
          Container(
            height: 1000,
            
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.only(top: 130),
            width: 500,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("images/fruits.jpg" ),fit: BoxFit.cover),

              borderRadius: BorderRadius.circular(90),
              color: Colors.white

            ),

          ),
          InkWell(
            onTap: () async {
              saveAccountType("transporter");
              String? type = await getAccountType();
              print(type);




            },
            child: Container(
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(60)
              ),
              margin: EdgeInsets.only(top: 270),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),

                    child: Image.asset("images/truck.jpg" , fit: BoxFit.cover, height: 150,width: 150,),

                  ),
                  Container(
                      decoration:BoxDecoration(color: Colors.lightGreen,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))

                      ) ,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(left: 8,right: 8,bottom: 5),
                      child: Text("Transporter" , style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold ,color: Colors.white),))
                ],
              ),
            ),
          ),
          Column(
            children: [

              SizedBox(height: 88),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green ,width: 2 ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.lightGreen,
                ),
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedHeaderText(),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  saveAccountType("farmer");
                  String? type = await getAccountType();
                  print(type);





                },
                child: Container(
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(60)
                  ),
                  margin: EdgeInsets.only(left: 160,top: 20),

                  child:
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),





                            child: Image.asset("images/farmer.jpg" , fit: BoxFit.cover, height: 150,width: 150,),


                        ),
                        Container(
                            decoration:BoxDecoration(color: Colors.lightGreen,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))

                            ) ,
                            padding: EdgeInsets.only(left: 26,right: 26,bottom: 5),


                            child: Text("Farmer" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold , color: Colors.white),))
                      ],
                    ),
                  ),
                ),


              InkWell(
                onTap: () async {
                  saveAccountType("trader");
                  String? type = await getAccountType();
                  print(type);






                },
                child: Container(
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(60)
                  ),
                  margin: EdgeInsets.only(top: 100,left: 110),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),

                        child: Image.asset("images/trader.jpg" , fit: BoxFit.cover, height: 150,width: 150,),

                      ),
                      Container(
                          decoration:BoxDecoration(color: Colors.lightGreen,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))

                          ) ,
                          padding: EdgeInsets.only(left: 26,right: 26,bottom: 5),
                          child: Text("Trader" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold ,color: Colors.white),))
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.white
                ),
                height: 80,


                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.symmetric(horizontal: 20),

                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      children: [
                        Text(
                          "Have Account?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          child: Text(
                            " Login now ",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),

                        ),
                      ],
                    ),
                ),
                ),

            ],
          ),
          Container(
            height: 70,
            margin: EdgeInsets.only(top: 18 ,left: 50,right: 50),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green ,width: 2 ),
              borderRadius: BorderRadius.circular(60),
              color: Colors.white,
            ),

              child:
              Center(
                child: Text(
                  "GREEN TRADE",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),

          ),
        ],
      ),
    );
  }

  Widget accountOption(String type, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: color,
      ),
      height: 100,
      width: 600,
      child: MaterialButton(
        onPressed: ()
    {}
        ,
        child: Text(
          type,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
    );
  }
}

