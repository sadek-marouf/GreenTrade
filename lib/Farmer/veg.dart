
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Service/framwork.dart';

class vegetables extends StatelessWidget {
  final List<Get_Products> pord  ;
  const vegetables({super.key , required this.pord} );

  @override
  Widget build(BuildContext context) {
    return Container(
      child:ListView.builder(

          itemCount: pord.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [Expanded(child: Image.asset(pord[index].image)),
                Text(pord[index].name ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18),)

                ,
                  Row(
                    children: [Text("Price : " , style: TextStyle(   fontSize: 18),) , Text(pord[index].name ,style:TextStyle( fontSize: 18) ,)],
                  ),
                  Row(
                    children: [Text("Quantity" , style: TextStyle( fontSize: 18),) ,Text(pord[index].name ,style:TextStyle( fontSize: 18) ,) ],
                  )

                ],
              ),
            );
          },)

    );
  }
}

