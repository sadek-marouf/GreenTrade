import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // القسم الأول
          Expanded(
            child: Container(
              color: Colors.green[200],
              child: Center(child: Image.asset("images/farmer.jpg")),
            ),
          ),
          // الخط المتموج الأول
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: WavePainter(color: Colors.green[200]!, reverse: false),
              child: Container(),
            ),
          ),
          // القسم الثاني
          Expanded(
            child: Container(
              color: Colors.green[400],
              child: Center(child: Image.asset("images/truck.jpg")),
            ),
          ),
          // الخط المتموج الثاني
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: WavePainter(color: Colors.blue[400]!, reverse: false),
              child: Container(),
            ),
          ),
          // القسم الثالث
          Expanded(
            child: Container(
              color: Colors.green[600],
              child: Center(child: Image.asset("images/trader.jpg" ,fit: BoxFit.fitHeight,)),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final bool reverse;

  WavePainter({required this.color, this.reverse = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (reverse) {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(size.width / 4, 0, size.width / 2, size.height);
      path.quadraticBezierTo(3 * size.width / 4, 2 * size.height, size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, 0);
      path.quadraticBezierTo(3 * size.width / 4, -size.height, size.width, 0);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  }

