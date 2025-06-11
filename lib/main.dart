
import 'package:farm1/WelcomPage.dart';
import 'package:farm1/auth/homepageselect.dart';



import 'package:farm1/welcom/pageone.dart';
import 'package:farm1/welcom/pagethree.dart';
import 'package:farm1/welcom/pagetwo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Farmer/farmerdashbord.dart';
import 'Farmer/nave.dart';
import 'Farmer/profile.dart';
import 'Trader/homepage.dart';
import 'Trader/nav_tra.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/register_bloc.dart';


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
        home:AnimatedNavBarPageTrader(),


        routes: {
          'page one' :(context) => const Pageone(),
          'page two' :(context) => const Pagetwo(),
          'page three' :(context) => const Pagethree(),
          'login': (context) => const LoginPage(),
          'register': (context) => const RegisterPage(),
          'welcome' : (context) => FarmerHomePage(),
          'select' : (context) => HomePageSelect(),


          'profile' : (context) => const ProfileScreen() ,
         },
      )
    ) ;
  }}
