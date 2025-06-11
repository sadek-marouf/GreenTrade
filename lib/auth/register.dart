import 'package:farm1/auth/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/Service/framwork.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController villageController = TextEditingController();

  String? selectedGovernorate;
  final List<String> governorates = [
    'Damascus', 'Rif Dimashq', 'Aleppo', 'Homs', 'Hama',
    'Latakia', 'Tartus', 'Idlib', 'Daraa', 'Quneitra',
    'As-Suwayda', 'Deir ez-Zor', 'Al-Hasakah', 'Raqqa'
  ];


  Future<String?> getAccountType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accountType');
  }

  @override
  Widget build(BuildContext context) {



      String? type = getAccountType().toString();






    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title:
           Text(
              "Green Trade",
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

        backgroundColor: Colors.green[600],

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.lightGreen],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BlocConsumer<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Registration successful!")),
                );
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registration failed:${state.message}")),
                );
              }
            },
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  Text(
                    "Please Enter Your Personal Information ",
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Costmer(iconn: Icons.person, controler: firstNameController, title: "First Name"),
                  Costmer(iconn: Icons.person, controler: lastNameController, title: 'Last Name *'),
                  Costmer(iconn: Icons.email, controler: emailController, title: 'Email Address *', textInputType: TextInputType.emailAddress),
                  Costmer(iconn: Icons.phone, controler: phoneController, title: 'Phone Number', textInputType: TextInputType.phone),
                  Costmer(iconn: Icons.lock, controler: passwordController, title: 'Password', isPassword: true),
                  Costmer(iconn: Icons.lock, controler: confirmPasswordController, title: 'Confirm Password', isPassword: true, ),

                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      hint: Row(
                        children: const [
                          Icon(Icons.public, size: 30 , color: Colors.lightGreen,),
                          Text(" Select Governorate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                        ],
                      ),
                      value: selectedGovernorate,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: governorates.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGovernorate = newValue!;
                        });
                      },
                    ),
                  ),

                  Costmer(iconn: Icons.location_city, controler: cityController, title: "City " ),
                  Costmer(iconn: Icons.holiday_village, controler: villageController, title: "Village"),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "By clicking 'Register' you agree to our",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        child: const Text('Terms of use', style: TextStyle(color: Colors.blue, fontSize: 18)),
                      ),
                      const Text("&", style: TextStyle(fontSize: 18)),
                      MaterialButton(
                        onPressed: () {},
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
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
                            child: Container(
                              padding: EdgeInsets.all(2),

                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),color: Colors.white,),
                              child: Text(
                                "Login Now",
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      )) ,

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("The password and confirmation do not match!")  ,backgroundColor: Colors.red,),
                          );
                          return;
                        }


                        if(firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty ) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("All fields marked with an asterisk must be completed." ) ,backgroundColor: Colors.red,),
                          );
                          return;
                        }


                        // تخزين البيانات باستخدام SharedPreferences

                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.setString('first_name', firstNameController.text);
                        await prefs.setString('last_name', lastNameController.text);
                        await prefs.setString('email register', emailController.text);
                        await prefs.setString('phone', phoneController.text);
                        await prefs.setString('governorate', selectedGovernorate!);
                        await prefs.setString('city', cityController.text);
                        await prefs.setString('village', villageController.text);
                        // من الأفضل عدم تخزين كلمة السر للحماية


                        // إنشاء موديل المستخدم



                        // إرسال البيانات لـ Bloc
                        context.read<RegistrationBloc>().add(SubmitRegistrationEvent());

                      },
                      child: const Text("Register", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
// lib/models/user_model.dart

class UserModel {
  final String accounttype;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String governorate;
  final String city;
  final String village;

  UserModel({
    required this.accounttype,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.governorate,
    required this.city,
    required this.village,
  });


  Map<String, dynamic> toMap() {
    return {
      'account type': accounttype,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'governorate': governorate,
      'city': city,
      'village': village,
    };
  }
}
class color {

}
//


//201





//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../register_bloc.dart';
// import 'framwork.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController villageController = TextEditingController();
//
//   String? selectedGovernorate;
//   final List<String> governorates = [
//     'Damascus', 'Rif Dimashq', 'Aleppo', 'Homs', 'Hama',
//     'Latakia', 'Tartus', 'Idlib', 'Daraa', 'Quneitra',
//     'As-Suwayda', 'Deir ez-Zor', 'Al-Hasakah', 'Raqqa'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           title: const Center(
//             child: Text(
//               "Join Now For Free",
//               style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//           ),
//           backgroundColor: Colors.green[600],
//         ),
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.white, Colors.lightGreen],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//             BlocConsumer<RegistrationBloc, RegistrationState>(
//                 listener: (context, state) {
//                   if (state is RegisterSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("تم التسجيل بنجاح!"))
//                     );
//                   } else if (state is RegisterError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("فشل التسجيل: ${state.message}"))
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is RegisterLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return ListView(
//                     padding: const EdgeInsets.all(16),
//                     children: [
//                       Text(
//                         "Register As Farmer",
//                         style: TextStyle(
//                           color: Colors.blue[600],
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//
//                       Costmer(iconn: Icons.person, controler: firstNameController, title: "First Name"),
//                       Costmer(iconn: Icons.person, controler: lastNameController, title: 'Last Name *'),
//                       Costmer(iconn: Icons.email, controler: emailController, title: 'Email Address *', textInputType: TextInputType.emailAddress),
//                       Costmer(iconn: Icons.lock, controler: passwordController, title: 'Password', isPassword: true),
//                       Costmer(iconn: Icons.lock, controler: confirmPasswordController, title: 'Confirm Password', isPassword: true),
//
//                       Container(
//                         height: 60,
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         margin: const EdgeInsets.only(bottom: 30),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(60),
//                             color: Colors.white
//                         ),
//                         child: DropdownButton<String>(
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                           hint: Row(
//                             children: const [
//                               Icon(Icons.public, color: Colors.blue, size: 30),
//                               Text(" Select Governorate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
//                             ],
//                           ),
//                           value: selectedGovernorate,
//                           isExpanded: true,
//                           underline: const SizedBox(),
//                           items: governorates.map((String item) {
//                             return DropdownMenuItem<String>(
//                               value: item,
//                               child: Text(item),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedGovernorate = newValue!;
//                             });
//                           },
//                         ),
//                       ),
//
//                       Costmer(iconn: Icons.location_city, controler: cityController, title: "City"),
//                       Costmer(iconn: Icons.holiday_village, controler: villageController, title: "Village"),
//                       const SizedBox(height: 20),
//
//                       const Center(
//                         child: Text(
//                           "By clicking 'Register' you agree to our",
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           MaterialButton(
//                             onPressed: () {},
//                             child: const Text('Terms of use', style: TextStyle(color: Colors.blue, fontSize: 18)),
//                           ),
//                           const Text("&", style: TextStyle(fontSize: 18)),
//                           MaterialButton(
//                             onPressed: () {},
//                             child: const Text(
//                               'Privacy Policy',
//                               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(60),
//                         ),
//                         margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                         child: MaterialButton(
//                           onPressed: () {
//                             if (passwordController.text != confirmPasswordController.text) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("كلمة السر وتأكيدها غير متطابقين!"))
//                               );
//                               return;
//                             }
//
//                             final user = UserModel(
//                               firstName: firstNameController.text,
//                               lastName: lastNameController.text,
//                               email: emailController.text,
//                               phone: phoneController.text,
//                               password: passwordController.text,
//                               governorate: selectedGovernorate ?? '',
//                               city: cityController.text,
//                               village: villageController.text,
//                             );
//
//                             BlocProvider.of<RegistrationBloc>(context).add();
//                           },
//                           child: const Text("Register", style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//             )
//           ],
//         ),
//       );
//
//   }
// }
//
//
//
//
// // import 'package:farm1/auth/framwork.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class RegisterPage extends StatefulWidget {
// //   const RegisterPage({super.key});
// //
// //   @override
// //   State<RegisterPage> createState() => _RegisterPageState();
// // }
// //
// // class _RegisterPageState extends State<RegisterPage> {
// //   final TextEditingController firstNameController = TextEditingController();
// //   final TextEditingController lastNameController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController confirmPasswordController =
// //   TextEditingController();
// //   final TextEditingController GovernorateController = TextEditingController() ;
// //   final TextEditingController CityController = TextEditingController() ;
// //   final TextEditingController VillageController = TextEditingController() ;
// //
// //   Future<void> saveUserData() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('firstName', firstNameController.text);
// //     await prefs.setString('lastName', lastNameController.text);
// //     await prefs.setString('email', emailController.text);
// //     await prefs.setString('phone', phoneController.text);
// //     await prefs.setString('password', passwordController.text);
// //     await prefs.setString('Governorate', GovernorateController.text);
// //     await prefs.setString('City', CityController.text);
// //     await prefs.setString('Village', VillageController .text) ;
// //   }
// //
// //   Future<void> sendDataToServer() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String accountType = prefs.getString('accountType') ?? '';
// //     String firstName = prefs.getString('firstName') ?? '';
// //     String lastName = prefs.getString('lastName') ?? '';
// //     String email = prefs.getString('email') ?? '';
// //     String phone = prefs.getString('phone') ?? '';
// //     String password = prefs.getString('password') ?? '';
// //     String Governorate = prefs.getString('Governorate') ?? '';
// //     String City = prefs.getString('City') ?? '';
// //     String Village = prefs.getString('Village') ?? '';
// //
// //     print('Sending to Server:');
// //     print(
// //         'Type: $accountType, Name: $firstName $lastName, Email: $email, Phone: $phone, Password: $password ,Governorate : $Governorate  , City : $City  , Village : $Village' );
// //
// //     // هنا ضيف كود الـ HTTP POST الخاص بالسيرفر تبعك
// //   }
// //
// //   final List<String> governorates = [
// //     'Damascus',
// //     'Rif Dimashq',
// //     'Aleppo',
// //     'Homs',
// //     'Hama',
// //     'Latakia',
// //     'Tartus',
// //     'Idlib',
// //     'Daraa',
// //     'Quneitra',
// //     'As-Suwayda',
// //     'Deir ez-Zor',
// //     'Al-Hasakah',
// //     'Raqqa'
// //   ];
// //   String? selectedGovernorate ;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Center(
// //           child: Text(
// //             "Join Now For Free",
// //             style: TextStyle(
// //                 color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         backgroundColor: Colors.green[600],
// //       ),
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Colors.white, Colors.lightGreen],
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //           ListView(
// //             padding: const EdgeInsets.all(16),
// //             children: [
// //               Text(
// //                 "Register As Farmer",
// //                 style: TextStyle(
// //                     color: Colors.blue[600],
// //                     fontSize: 30,
// //                     fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 15),
// //               Costmer(
// //                   iconn: Icons.person,
// //                   controler: firstNameController,
// //                   title: "First Name"),
// //               Costmer(
// //                   iconn: Icons.person,
// //                   controler: lastNameController,
// //                   title: 'Last Name *'),
// //               Costmer(
// //                 iconn: Icons.email,
// //                 controler: emailController,
// //                 title: 'Email Address *',
// //                 textInputType: TextInputType.emailAddress,
// //               ),
// //
// //               Costmer(
// //                   iconn: Icons.lock,
// //                   controler: passwordController,
// //                   title: 'Password',
// //                   isPassword: true),
// //               Costmer(
// //                   iconn: Icons.lock,
// //                   controler: confirmPasswordController,
// //                   title: 'Confirm Password',
// //                   isPassword: true),
// //               Container(
// //
// //                 height: 60,
// //                 padding: EdgeInsets.symmetric(horizontal: 10),
// //                 margin: EdgeInsets.only(bottom: 30),
// //                 decoration: BoxDecoration(
// //                     border: Border.all(color: Colors.grey),
// //                     borderRadius: BorderRadius.circular(60),
// //                     color: Colors.white),
// //                 child: DropdownButton<String>(
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: Colors.black),
// //                   hint: Row(
// //                     children: [
// //                       Icon(Icons.public , color: Colors.blue,size: 30,),
// //                       Text(" Select Governorate" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 , color: Colors.black),),
// //
// //                     ],
// //                   ),
// //                   value: selectedGovernorate,
// //                   isExpanded: true,
// //                   underline: SizedBox(),
// //                   items: governorates.map((String item) {
// //                     return DropdownMenuItem<String>(
// //                       value: item,
// //                       child: Text(item),
// //                     );
// //                   }).toList(),
// //                   onChanged: (String? newValue) {
// //                     setState(() {
// //                       selectedGovernorate = newValue!;
// //                     });
// //                   },
// //                 ),
// //               ),
// //               Costmer(iconn: Icons.location_city, controler:CityController, title: "City") ,
// //               Costmer(iconn: Icons.holiday_village, controler: VillageController, title: "Village") ,
// //               SizedBox(height: 20),
// //               Center(
// //                 child: Text(
// //                   "By clicking 'Register' you agree to our",
// //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   MaterialButton(
// //                     onPressed: () {},
// //                     child: Text('Terms of use',
// //                         style: TextStyle(color: Colors.blue, fontSize: 18)),
// //                   ),
// //                   Text(
// //                     "&",
// //                     style: TextStyle(fontSize: 18),
// //                   ),
// //                   MaterialButton(
// //                     onPressed: () {},
// //                     child: Text(
// //                       'Privacy Policy',
// //                       style: TextStyle(
// //                           color: Colors.blue,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 18),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue,
// //                   borderRadius: BorderRadius.circular(60),
// //                 ),
// //                 margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
// //                 child: MaterialButton(
// //                   onPressed: () async {
// //                     await saveUserData();
// //                     await sendDataToServer();
// //                   },
// //                   child:
// //                   Text("Register", style: TextStyle(color: Colors.white)),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }