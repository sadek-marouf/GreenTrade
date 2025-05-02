
import 'package:farm1/WelcomPage.dart';
import 'package:farm1/auth/homepageselect.dart';
import 'package:farm1/test.dart';
import 'package:farm1/welcom/pageone.dart';
import 'package:farm1/welcom/pagethree.dart';
import 'package:farm1/welcom/pagetwo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/login.dart';
import 'auth/register.dart';
import 'counter_bloc.dart';
import 'farmerdashbord.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: LoginPage(),routes: {
    //       'login': (context) => const LoginPage(),
    //       'register': (context) => const RegisterPage(),
    //       'homes_elect': (context) => const HomePageSelect(),
    //     },) ;

    return  BlocProvider(
        create: (_) => RegistrationBloc(),
    child :

      MaterialApp(
        home:Pageone(),


        routes: {
          'page one' :(context) => const Pageone(),
          'page two' :(context) => const Pagetwo(),
          'page three' :(context) => const Pagethree(),
          'login': (context) => const LoginPage(),
          'register': (context) => const RegisterPage(),
          'homes_select': (context) => const HomePageSelect(),
          'farmer'   : (context) => const FarmerDashboard() ,
        },
      )
    ) ;
  }}