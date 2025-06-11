import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagethree extends StatefulWidget {
  const Pagethree({super.key});

  @override
  State<Pagethree> createState() => _PagethreeState();
}

class _PagethreeState extends State<Pagethree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Stack(
        children: [


          Container(
            child: Image.asset("images/welcom3.jpg" ,fit: BoxFit.fitHeight,),
          ),
          Container(
            margin: EdgeInsets.only(top: 580),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.lightGreen],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),

            ),
            child: Column(

              children: [Center(

                  child: Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25,top: 20),
                    child: Text("their are text in this place ,how tel the user more about application " , style: TextStyle(fontSize: 22),),
                  )) ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: MaterialButton(onPressed: (){
                        Navigator.of(context).pushNamed('page two');
                      },

                        child:
                        Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_left_outlined , color: Colors.white,size: 25,),
                            Text("back",style: TextStyle(fontSize: 25 ,color: Colors.white), ),
                          ],
                        )

                        ,),
                    ), Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black
                      ),
                      margin: EdgeInsets.symmetric(vertical: 30 ,horizontal: 5),
                      child: MaterialButton(onPressed: (){
                        Navigator.of(context).pushReplacementNamed('select');
                      },

                        child:
                        Row(
                          children: [

                            Text("Started",style: TextStyle(fontSize: 25 ,color: Colors.white), ),
                            Icon(Icons.keyboard_double_arrow_right_outlined ,color: Colors.white,size: 25,)
                          ],
                        )

                        ,),
                    ),
                  ],
                )

              ],),

          )
        ],
      ),
    );;
  }
}
