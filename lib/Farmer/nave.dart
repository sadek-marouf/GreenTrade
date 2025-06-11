import 'package:farm1/Farmer/profile.dart';
import 'package:farm1/WelcomPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../auth/login_bloc.dart';
import 'Bloc/Farmer_bloc/Product/products_bloc.dart';

import 'Products/addproduct.dart';
import 'Service/repositories/products_repository.dart';




class AnimatedNavBarPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = ProductsRepository(http.Client());

    return  MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>(
          create: (_) => ProductsBloc(repository),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return AnimatedNavBarPage();
        },
      ),
    );
    ;
  }
}

class AnimatedNavBarPage extends StatefulWidget {
  @override
  _AnimatedNavBarPageState createState() => _AnimatedNavBarPageState();
}

class _AnimatedNavBarPageState extends State<AnimatedNavBarPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  int _selectedIndex = 0;


  final List<Widget> _pages = [
    FarmerHomePage(),
    ProfileScreen(),
    Center(child: Text('')),
    Center(child: Text('')),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // خارج الشاشة من الأسفل
      end: Offset.zero,              // إلى مكانه الطبيعي
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); // تشغيل الأنيميشن عند بداية الصفحة
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFFA8E6A1), // Light green
        onPressed: () {
          final productsBloc = BlocProvider.of<ProductsBloc>(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BlocProvider.value(
                value: productsBloc,
                child: AddProductModal(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: _selectedIndex == 0 ? 8 : 0,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  iconSize: 30,
                  color: _selectedIndex == 0 ? Colors.lightGreen : Colors.grey,
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  color: _selectedIndex == 1 ? Colors.lightGreen : Colors.grey,
                  icon: Icon(Icons.person),
                  iconSize: 30,
                  onPressed: () => _onItemTapped(1),
                ),
                SizedBox(width: _selectedIndex == 0 ? 48 : 0), // مساحة الزر الأوسط
                IconButton(
                  icon: Icon(Icons.article),
                  iconSize: 30,
                  color: _selectedIndex == 2 ? Colors.lightGreen : Colors.grey,
                  onPressed: () => _onItemTapped(2),
                ),
                IconButton(
                  icon: Icon(Icons.support_agent),
                  iconSize: 30,
                  color: _selectedIndex == 3 ? Colors.lightGreen : Colors.grey,
                  onPressed: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
