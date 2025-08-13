// login.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/Service/framwork.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void _navigateToHome(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('userType');

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

    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,


          body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
          ),
          Container(
            height: size.height * 1.0,
            margin: EdgeInsets.symmetric(
                vertical: size.height * 0.019, horizontal: size.width * 0.04),
            padding:
                EdgeInsets.only(top: size.height * 0.05, left: 10, right: 10),
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
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                Costmer(
                    iconn: Icons.email,
                    controler: emailController,
                    title: "Email"),
                Costmer(
                    iconn: Icons.password,
                    controler: passwordController,
                    title: "Password"),
                Row(
                  children: [
                    Text(
                      "Dont have An Account?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('select');
                      },
                      child: Text(
                        "Sing In Now",
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          Navigator.of(context).pushReplacementNamed("nav");
                        } else if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Failed: ${state.error}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child:
                          // BlocBuilder لعرض الحالة أثناء الضغط
                          BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoginLoading) {
                            return CircularProgressIndicator(
                              color: Colors.green,
                            );
                          } else if (state is LoginFailure) {
                            return Column(
                              children: [
                                Text(
                                  "Login Failed: ${state.error}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildLoginButton(context, emailController,
                                    passwordController),
                              ],
                            );
                          } else if (state is LoginSuccess) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _navigateToHome(context);
                            });
                            return Text(
                              "Login Successful!",
                              style: TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return _buildLoginButton(
                                context, emailController, passwordController);
                          }
                        },
                      ),
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }
}

// زر تسجيل الدخول وإرسال البيانات إلى bloc
Widget _buildLoginButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController) {
  return Container(
    width: 400,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.lightGreen,
      borderRadius: BorderRadius.circular(60),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: MaterialButton(
      onPressed: () {
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please Enter Your Personal Information"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(email, password),
        );
      },
      child: Text(
        "Login",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}
