import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagetwo extends StatefulWidget {
  const Pagetwo({super.key});

  @override
  State<Pagetwo> createState() => _PagetwoState();
}

class _PagetwoState extends State<Pagetwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Stack(
        children: [


          Container(
            child: Image.asset("images/wecom1.jpg" ,fit: BoxFit.fitHeight,),
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
                    padding: const EdgeInsets.symmetric(vertical: 25 ,horizontal: 20),
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
                      margin: EdgeInsets.symmetric( horizontal: 5),
                      child: MaterialButton(onPressed: (){
                        Navigator.of(context).pushNamed('page one');
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
                      margin: EdgeInsets.symmetric(vertical: 10 ,horizontal: 5),
                      child: MaterialButton(onPressed: (){
                        Navigator.of(context).pushNamed('page three');
                      },

                        child:
                        Row(
                          children: [

                            Text("Next",style: TextStyle(fontSize: 25 ,color: Colors.white), ),
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
    );
  }
}
