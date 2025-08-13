
import 'package:farm1/Trader/serch.dart';
import 'package:farm1/WelcomPage.dart';
import 'package:farm1/auth/homepageselect.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



import 'package:farm1/welcom/pageone.dart';
import 'package:farm1/welcom/pagethree.dart';
import 'package:farm1/welcom/pagetwo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Farmer/nave.dart';
import 'Farmer/profile.dart';

import 'Trader/homepage.dart';
import 'Trader/nav_tra.dart';
import 'Trader/test.dart';
import 'Trader/visitfarmer.dart';
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
        locale: const Locale('ar'), // تعيين اللغة للعربية
        supportedLocales: const [
          Locale('ar'), // العربية
          Locale('en'), // الإنكليزية (اختياري)
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home:LoginPage(),


        routes: {
          'page one' :(context) => const Pageone(),
          'page two' :(context) => const Pagetwo(),
          'page three' :(context) => const Pagethree(),
          'login': (context) => const LoginPage(),
          'register': (context) => const RegisterPage(),

          'select' : (context) => HomePageSelect(),
          'nav' : (context) => AnimatedNavBarPageWrapper() ,
           'nav_t' : (context) => NavBarPageTrader() ,
          'profile' : (context) => const ProfileScreen() ,
          'home_t': (context) => TraderProductsPage() ,
          'serch': (context) => Bserch()
         },
      )
    ) ;
  }}
