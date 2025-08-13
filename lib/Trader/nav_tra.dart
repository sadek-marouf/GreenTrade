
import 'package:farm1/Farmer/Service/repositories/products_repository.dart';
import 'package:farm1/Trader/Trader_Bloc/farmers_bloc.dart';
import 'package:farm1/Trader/Trader_Bloc/getproductfarmer/visitfarmer_bloc.dart';

import 'package:farm1/Trader/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;


class NavBarPageTrader extends StatelessWidget {
  final repository = ProductsRepository(http.Client());
 NavBarPageTrader({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(providers: [
      BlocProvider<FarmersBloc>(create: (_) => FarmersBloc() ),
      BlocProvider<VisitfarmerBloc>(create: (_) => VisitfarmerBloc(repository))

    ], child: Builder(builder: (context){
      return AnimatedNavBarPageTrader() ;
    }));
  }
}



class AnimatedNavBarPageTrader extends StatefulWidget {
  @override
  _AnimatedNavBarPageTraderState createState() => _AnimatedNavBarPageTraderState();
}

class _AnimatedNavBarPageTraderState extends State<AnimatedNavBarPageTrader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  int _selectedIndex = 0;


  final List<Widget> _pages = [
    TraderProductsPage(),

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
      end: Offset.zero, // إلى مكانه الطبيعي
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: ClipRRect(


          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: _selectedIndex == 0 ? 8 : 0,
            child: SizedBox(
              height: 40, // زيادة الارتفاع لراحة الأزرار
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.home),
                    iconSize: 30,
                    color:
                    _selectedIndex == 0 ? Colors.lightGreen : Colors.grey,
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    color:
                    _selectedIndex == 1 ? Colors.lightGreen : Colors.grey,
                    onPressed: () => _onItemTapped(1),
                  ),

                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.article),
                    iconSize: 30,
                    color:
                    _selectedIndex == 2 ? Colors.lightGreen : Colors.grey,
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.support_agent),
                    iconSize: 30,
                    color:
                    _selectedIndex == 3 ? Colors.lightGreen : Colors.grey,
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}