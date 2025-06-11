import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageSelect extends StatefulWidget {
  @override
  _HomePageSelectState createState() => _HomePageSelectState();
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(color: Colors.lightGreen),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: size.width * 0.03, horizontal: size.height * 0.02),
              padding:
                  EdgeInsets.only(top: size.height * 0.1, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.lightGreen,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "images/image.jpg",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // اسم التطبيق
                  Text(
                    'GreenTrade',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(height: 30),
                  // العنوان
                  Text(
                    'Chose Account Type :',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  // البطاقات
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          children: [
                            Card(

                              color: Colors.lightGreen[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              child: InkWell(
                                onTap: () async {
                                  saveAccountType("farmer");
                                  String? type = await getAccountType();
                                  print(type);
                                  Navigator.of(context).pushNamed('register');
                                },
                                child: ListTile(
                                  leading: Icon(Icons.eco,
                                      color: Colors.white, size: 32),
                                  title: Text(
                                    'Farmer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                ),
                              ),
                            ),

                            Card(
                              color: Colors.lightGreen[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              child: InkWell(
                                onTap: () async {
                                  saveAccountType("trader");
                                  String? type = await getAccountType();
                                  print(type);
                                  Navigator.of(context).pushNamed('register');
                                },
                                child: ListTile(
                                  leading: Icon(Icons.storefront,
                                      color: Colors.white, size: 32),
                                  title: Text(
                                    "Trader",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have Account ? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("login");
                        },
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomePageSelect extends StatefulWidget {
//   const HomePageSelect({super.key});
//
//   @override
//   State<HomePageSelect> createState() => _HomePageSelectState();
// }
//
// class _HomePageSelectState extends State<HomePageSelect> {
//   Future<void> saveAccountType(String type) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accountType', type);
//   }
//
//   Future<String?> getAccountType() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accountType');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: size.height,
//             width: size.width,
//             color: Colors.lightGreen,
//           ),
//           Container(
//             color: Colors.lightGreen,
//           ),
//           Container(
//             height: size.height,
//             margin: EdgeInsets.only(top: size.height * 0.03),
//             padding: EdgeInsets.only(top: size.height * 0.13),
//             width: size.width,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("images/fruits.jpg"),
//                 fit: BoxFit.cover,
//               ),
//               borderRadius: BorderRadius.circular(size.width * 0.2),
//               color: Colors.white,
//             ),
//           ),
//           // Driver Button
//           Positioned(
//             top: size.height * 0.33,
//             left: size.width * 0.02,
//             child: buildAccountCard(
//               context,
//               image: "images/truck.jpg",
//               label: " Driver ",
//               type: "Driver",
//               size: size,
//               alignment: Alignment.centerLeft,
//             ),
//           ),
//           // Content and Other Buttons
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
//             child: Column(
//               children: [
//                 SizedBox(height: size.height * 0.11),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.green, width: 2),
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.lightGreen,
//                   ),
//                   margin: EdgeInsets.only(top: 10),
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: AnimatedHeaderText(),
//                 ),
//                 SizedBox(height: size.height * 0.015),
//                 // Farmer Button
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: buildAccountCard(
//                     context,
//                     image: "images/farmer.jpg",
//                     label: "Farmer",
//                     type: "farmer",
//                     size: size,
//                     alignment: Alignment.centerRight,
//                   ),
//                 ),
//                 SizedBox(height: size.height * 0.12),
//                 // Trader Button
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: buildAccountCard(
//                     context,
//                     image: "images/trader.jpg",
//                     label: "Trader",
//                     type: " trader ",
//                     size: size,
//                     alignment: Alignment.centerRight,
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(60),
//                     color: Colors.white,
//                   ),
//                   height: size.height * 0.1,
//                   margin: EdgeInsets.only(top: size.height * 0.03),
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       children: [
//                         Text(
//                           "Have Account?",
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pushReplacementNamed("login");
//                           },
//                           child: Text(
//                             " Login now ",
//                             style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: size.height * 0.02,
//             left: size.width * 0.15,
//             right: size.width * 0.15,
//             child: Container(
//               height: size.height * 0.07,
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green, width: 2),
//                 borderRadius: BorderRadius.circular(60),
//                 color: Colors.white,
//               ),
//               child: Center(
//                 child: Text(
//                   "GREEN TRADE",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildAccountCard(BuildContext context,
//       {required String image,
//         required String label,
//         required String type,
//         required Size size,
//         required Alignment alignment}) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(size.width * 0.15),
//           color: Colors.white,
//         ),
//         child: InkWell(
//           onTap: () async {
//             await saveAccountType(type);
//             String? savedType = await getAccountType();
//             print(savedType);
//             Navigator.of(context).pushNamed('register');
//           },
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(size.width * 0.15)),
//                 child: Image.asset(
//                   image,
//                   fit: BoxFit.cover,
//                   height: size.height * 0.18,
//                   width: size.width * 0.4,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.lightGreen,
//                   borderRadius: BorderRadius.vertical(
//                       bottom: Radius.circular(size.width * 0.15)),
//                 ),
//                 padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.07, vertical: 5),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AnimatedHeaderText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "اختر نوع الحساب",
//       style: TextStyle(
//           fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//     );
//   }
// }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'framwork.dart';
//
// class HomePageSelect extends StatefulWidget {
//   const HomePageSelect({super.key});
//
//   @override
//   State<HomePageSelect> createState() => _HomePageSelectState();
// }
//
// class _HomePageSelectState extends State<HomePageSelect> {
//
//   Future<void> saveAccountType(String type) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('accountType', type);
//   }
//   Future<String?> getAccountType() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accountType');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: 1000,
//             width: 500,
//             decoration: BoxDecoration(color: Colors.lightGreen),
//
//           ),
//           Container(
//             color: Colors.lightGreen,
//
//           ),
//           Container(
//             height: 1000,
//
//             margin: const EdgeInsets.only(top: 25),
//             padding: const EdgeInsets.only(top: 130),
//             width: 500,
//             decoration: BoxDecoration(
//               image: DecorationImage(image: AssetImage("images/fruits.jpg" ),fit: BoxFit.cover),
//
//               borderRadius: BorderRadius.circular(90),
//               color: Colors.white
//
//             ),
//
//           ),
//           /////////زر الناقل
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 304 ,horizontal: 5),
//             child: Align(
//               alignment: Alignment.centerLeft,
//
//               child: Container(
//                 decoration: BoxDecoration(
//
//                     borderRadius: BorderRadius.circular(60),
//                     color: Colors.white
//                 ),
//
//
//                 child:
//                 InkWell(
//                   onTap: () async {
//                     saveAccountType("Driver");
//                     String? type = await getAccountType();
//                     print(type);
//                     Navigator.of(context).pushNamed('register');
//
//
//
//
//
//                   },
//                   child: Column(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),
//
//
//
//
//
//                         child: Image.asset("images/truck.jpg" , fit: BoxFit.cover, height: MediaQuery.of(context).size.height * 0.18,width: MediaQuery.of(context).size.width * 0.4),
//
//
//                       ),
//                       Container(
//                           decoration:BoxDecoration(color: Colors.lightGreen,
//                               borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))
//
//                           ) ,
//                           padding: EdgeInsets.only(left: 29,right: 29,bottom: 5 ,),
//
//
//                           child: Text("Driver" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold , color: Colors.white),))
//                     ],
//                   ),
//                 ),
//
//               ),
//             ),
//           ),
//
//
//           ////////الجسم//////////
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//
//                 SizedBox(height: 88),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.green ,width: 2 ),
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.lightGreen,
//                   ),
//                   margin: EdgeInsets.only(top: 10),
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: AnimatedHeaderText(),
//                 ),
//                 SizedBox(height: 10),
//                 //////////زر المزارع///////
//                 Align(
//                   alignment: Alignment.centerRight,
//
//                   child: Container(
//                       decoration: BoxDecoration(
//
//                           borderRadius: BorderRadius.circular(60),
//                         color: Colors.white
//                       ),
//
//
//                       child:
//                         InkWell(

//
//
//
//
//                           },
//                           child: Column(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),
//
//
//
//
//
//                                   child: Image.asset("images/farmer.jpg" , fit: BoxFit.cover, height: MediaQuery.of(context).size.height * 0.18,width: MediaQuery.of(context).size.width * 0.4),
//
//
//                               ),
//                               Container(
//                                   decoration:BoxDecoration(color: Colors.lightGreen,
//                                     borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))
//
//                                   ) ,
//                                   padding: EdgeInsets.only(left: 26,right: 26,bottom: 5),
//
//
//                                   child: Text("Farmer" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold , color: Colors.white),))
//                             ],
//                           ),
//                         ),
//
//                     ),
//                 ),
//                 SizedBox(height: 120,),
//                 /////////////زر التاجر//////////
//                 Align(
//                   alignment: Alignment.centerRight,
//
//                   child: Container(
//                     decoration: BoxDecoration(
//
//                         borderRadius: BorderRadius.circular(60),
//                         color: Colors.white
//                     ),
//
//
//                     child:
//                     InkWell(
//                       onTap: () async {
//                         saveAccountType("trader");
//                         String? type = await getAccountType();
//                         print(type);
//                         Navigator.of(context).pushNamed('register');
//
//
//
//
//
//                       },
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(60)),
//
//
//
//
//
//                             child: Image.asset("images/trader.jpg" , fit: BoxFit.cover, height: MediaQuery.of(context).size.height * 0.18,width: MediaQuery.of(context).size.width * 0.4),
//
//
//                           ),
//                           Container(
//                               decoration:BoxDecoration(color: Colors.lightGreen,
//                                   borderRadius: BorderRadius.only(bottomRight: Radius.circular(60) ,bottomLeft: Radius.circular(60))
//
//                               ) ,
//                               padding: EdgeInsets.only(left: 26,right: 26,bottom: 5),
//
//
//                               child: Text("Trader" , style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold , color: Colors.white),))
//                         ],
//                       ),
//                     ),
//
//                   ),
//                 ),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(60),
//                     color: Colors.white
//                   ),
//                   height: 80,
//
//
//                   margin: EdgeInsets.only(top: 30),
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//
//                   child:  Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                         children: [
//                           Text(
//                             "Have Account?",
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.bold),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.of(context).pushReplacementNamed("login");
//                             },
//                             child: Text(
//                               " Login now ",
//                               style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green),
//                             ),
//
//                           ),
//                         ],
//                       ),
//                   ),
//                   ),
//
//               ],
//             ),
//           ),
//           Container(
//             height: 70,
//             margin: EdgeInsets.only(top: 18 ,left: 50,right: 50),
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.green ,width: 2 ),
//               borderRadius: BorderRadius.circular(60),
//               color: Colors.white,
//             ),
//
//               child:
//               Center(
//                 child: Text(
//                   "GREEN TRADE",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//               ),
//
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget accountOption(String type, Color color) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(60),
//         color: color,
//       ),
//       height: 100,
//       width: 600,
//       child: MaterialButton(
//         onPressed: ()
//     {}
//         ,
//         child: Text(
//           type,
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 25),
//         ),
//       ),
//     );
//   }
// }
//
