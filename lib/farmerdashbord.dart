import 'package:farm1/auth/framwork.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final List<Product> products = [
    Product(name: "Tomato", quantity: "40", price: "2500"),
    Product(name: "Potato", quantity: "60", price: "2000"),
    Product(name: "Carrot", quantity: "30", price: "1800"),
  ];
  TextEditingController nameproductController = TextEditingController() ;
  TextEditingController QuantityController =TextEditingController() ;
  TextEditingController PriceController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:

      Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        padding: EdgeInsets.only(top: 100,left: 20,right: 20),
        
        child: Column(

          children: [
            ClipOval(



              child: Image.asset("images/perimage.jpg" ,height: 200,width: 200, fit: BoxFit.cover,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40,bottom: 20),
              
              child: Text("Sadek Marouf" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
      appBar: AppBar(

        backgroundColor: Colors.green,
        title: const Text(
          'Available Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Color(0xFF22577A),
                  width: 2,
                ),
              ),color: Colors.lightGreen[300],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product: ${product.name}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Icon(FontAwesomeIcons.seedling,
                            size: 30, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity: ${product.quantity} kg",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Icon(FontAwesomeIcons.cube,
                            size: 30, color: Colors.amberAccent),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price: ${product.price} SYP",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Icon(FontAwesomeIcons.dollarSign,
                            size: 30, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: Update
                          },
                          child: const Text('Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {

                            // TODO: Delete
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Costmer(iconn: Icons.production_quantity_limits, controler: nameproductController, title: "Name Of Product"),
                        Costmer(iconn: Icons.shopping_bag, controler: QuantityController, title: "QuantityController"),
                        Costmer(iconn: Icons.price_change, controler: PriceController, title:"Price") ,


                        ElevatedButton(
                          onPressed: () {


                            products.add(Product(name: nameproductController.text, quantity:QuantityController.text, price: PriceController.text)) ;
                            print(products);
                            setState(() {

                            });



                          },
                          child: Text('إضافة'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add , color: Colors.green[600],size: 35,),
      ),
    );
  }
}

class Product {
  final String name;
  final String quantity;
  final String price;

  Product({required this.name, required this.quantity, required this.price});
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class farmerdashbord extends StatefulWidget {
//   farmerdashbord({super.key});
//
//   @override
//   State<farmerdashbord> createState() => _farmerdashbordState();
// }
//
// class _farmerdashbordState extends State<farmerdashbord> {
//   final List<Product> products = [
//     Product(name: "tomatom", quantity: 40, price: 2500),
//     Product(name: "botuto", quantity: 60, price: 2000),
//     Product(name: "carot", quantity: 30, price: 1800),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green ,
//         title: Text(
//           'Available Products',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//               colors: [Colors.white, Colors.lightGreen],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             )),
//           ),
//           Container(child: Image.asset("images/im2.png"),)
//           ,
//           ListView.builder(
//             padding: EdgeInsets.all(12),
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               return Container(
//                 decoration: BoxDecoration(
//
//                 ),
//                 child: Container(
//
//                   child: Card(
//
//                     margin: EdgeInsets.only(bottom: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 4,
//
//                     child: Stack(
//                       children: [
//                         Container(
//
//                           color: Colors.white,
//                         )
//                         ,
//                       Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//
//                               decoration: BoxDecoration(
//
//                                 borderRadius: BorderRadius.circular(60)
//
//                               ),
//
//                   padding: EdgeInsets.all(5)
//                   ,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text("Product: ${product.name}",
//                                       style: TextStyle(
//                                           fontSize: 18, fontWeight: FontWeight.bold)),
//                                   Icon(FontAwesomeIcons.seedling,
//                                       size: 30, color: Colors.green),
//                                 ],
//                               ),
//                             ),
//                             Container(decoration: BoxDecoration(
//
//                                 borderRadius: BorderRadius.circular(60)
//                                     , border:Border.all(width: 2,color: Color(0xFF22577A) )
//
//                             ),
//
//                               padding: EdgeInsets.all(5)
//                               ,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Quantity: ${product.quantity} kg",
//                                     style: TextStyle(
//                                         fontSize: 18, fontWeight: FontWeight.bold),
//                                   ),
//                                   Icon(FontAwesomeIcons.cube,
//                                       size: 30, color: Colors.amberAccent),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//
//                                   borderRadius: BorderRadius.circular(60)
//
//
//                               ),
//
//                               padding: EdgeInsets.all(5)
//                               ,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Price: ${product.price} SYP",
//                                     style: TextStyle(
//                                         fontSize: 18, fontWeight: FontWeight.bold),
//                                   ),
//                                   Icon(FontAwesomeIcons.dollarSign,
//                                       size: 30, color: Colors.green),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     // TODO: التعديل
//                                   },
//                                   child: Text('Update' ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
//                                 ),
//                                 SizedBox(width: 8),
//                                 TextButton(
//                                   onPressed: () {
//                                     // TODO: الحذف
//                                   },
//
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(60) ,
//                                       color: Colors.lightGreen
//                                     ),
//                                     padding: EdgeInsets.all(5),
//                                     child: Text('Delete',
//                                         style: TextStyle(color: Colors.red ,fontWeight: FontWeight.bold , fontSize: 20)),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: فتح صفحة إضافة منتج
//         },
//         child: Icon(Icons.add),
//         tooltip: 'أضف منتج',
//       ),
//     );
//   }
// }
//
// class Product {
//   final String name;
//   final int quantity;
//   final int price;
//
//   Product({required this.name, required this.quantity, required this.price});
// }
//
// /*
//
//  */
