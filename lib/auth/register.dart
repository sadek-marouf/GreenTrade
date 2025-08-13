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
    void _navigateToHome(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('accountType');

      if (userType == 'farmer') {
        Navigator.of(context).pushReplacementNamed("nav");
      } else if (userType == 'trader') {
        Navigator.of(context).pushReplacementNamed("nav_t");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown user type: $userType")),
        );
      }
    }










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
                _navigateToHome(context);
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




                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.setString('first_name', firstNameController.text);
                        await prefs.setString('last_name', lastNameController.text);
                        await prefs.setString('email register', emailController.text);
                        await prefs.setString('phone', phoneController.text);
                        await prefs.setString('governorate', selectedGovernorate!);
                        await prefs.setString('city', cityController.text);
                        await prefs.setString('village', villageController.text);





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