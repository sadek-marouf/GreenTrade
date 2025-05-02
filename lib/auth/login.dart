// login.dart

import 'package:farm1/auth/framwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_register_bloc.dart';

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
    return BlocProvider(create: (context) => LoginRegisterBloc() , child:  Scaffold(
        body: Stack(
          children: [
            Container(
              height: 1000,
              width: 500,
              decoration: BoxDecoration(color: Colors.green[600]),
            ),
            Container(
              height: 1000,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              padding: const EdgeInsets.only(top: 130, left: 10, right: 10),
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
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
                            fontSize: 18,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('register');
                          },
                          child: Text(
                            "Sing In Now",
                            style: TextStyle(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child:
                      // BlocBuilder لعرض الحالة أثناء الضغط
                      BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
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
                                _buildLoginButton(context ,emailController , passwordController),
                              ],
                            );
                          } else if (state is LoginSuccess) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).pushReplacementNamed("homepage");
                            });
                            return Text(
                              "Login Successful!",
                              style: TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return _buildLoginButton(context , emailController , passwordController);
                          }
                        },
                      ),
                    )  ],
                    ),
            ),
    ),
            Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: 120),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60)),
                color: Colors.green[600],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  "images/image.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )),);
  }
}


// زر تسجيل الدخول وإرسال البيانات إلى bloc
Widget _buildLoginButton(BuildContext context, TextEditingController emailController, TextEditingController passwordController) {
  return Container(
    width: 400,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(60),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: MaterialButton(
      onPressed: () {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        BlocProvider.of<LoginRegisterBloc>(context).add(
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
