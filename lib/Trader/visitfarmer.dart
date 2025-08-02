import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class FarmerDetailsPage extends StatelessWidget {
  final farmer = {
    'name': 'Ahmad Al-Farmer',
    'phone': '+963987654321',
    'email': 'ahmad@example.com',
    'location': 'Latakia, Syria',
    'image': 'https://i.imgur.com/BoN9kdC.png',
  };

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Tomatoes',
      'price': 300,
      'oldPrice': 400,
      'type': 'vegetable',
      'image': 'https://i.imgur.com/FHMnsV0.jpg',
    },
    {
      'name': 'Potatoes',
      'price': 200,
      'oldPrice': null,
      'type': 'vegetable',
      'image': 'https://i.imgur.com/xAuhNjK.jpg',
    },
    {
      'name': 'Cucumbers',
      'price': 250,
      'oldPrice': null,
      'type': 'vegetable',
      'image': 'https://i.imgur.com/65Q5xkR.jpg',
    },
    {
      'name': 'Apples',
      'price': 500,
      'oldPrice': 600,
      'type': 'fruit',
      'image': 'https://i.imgur.com/QxCpF5l.jpg',
    },
    {
      'name': 'Bananas',
      'price': 350,
      'oldPrice': null,
      'type': 'fruit',
      'image': 'https://i.imgur.com/PKpZP0s.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final discounted =
    products.where((p) => p['oldPrice'] != null).toList();

    final vegetables =
    products.where((p) => p['type'] == 'vegetable').toList();
    final fruits =
    products.where((p) => p['type'] == 'fruit').toList();

    return Scaffold(
      backgroundColor: Colors.lightGreen.shade200,
      appBar: AppBar(
        title: Text('Farmer Details'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ------------ Farmer Info ------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(farmer['image']!),
                      ),
                      SizedBox(height: 10),
                      Text(farmer['name']!,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, size: 16),
                          SizedBox(width: 5),
                          Text(farmer['phone']!),
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {

                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 16),
                          SizedBox(width: 5),
                          Text(farmer['email']!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 5),
                          Text(farmer['location']!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ------------ Discounted Products Slider ------------
            if (discounted.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('🔥 Discounted Products',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900)),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: false,
                    ),
                    items: discounted.map((product) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Image.network(
                                      product['image'] as String,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(product['name'] as String,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text:
                                            '${product['oldPrice']} SYP  ',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration.lineThrough,
                                                color: Colors.red)),
                                        TextSpan(
                                            text: '${product['price']} SYP',
                                            style: TextStyle(
                                                color: Colors.green.shade800)),
                                      ])),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),

            // ------------ Vegetables Section ------------
            if (vegetables.isNotEmpty)
              buildProductSection(title: '🥦 Vegetables', list: vegetables),

            // ------------ Fruits Section ------------
            if (fruits.isNotEmpty)
              buildProductSection(title: '🍎 Fruits', list: fruits),
          ],
        ),
      ),
    );
  }

  Widget buildProductSection({
    required String title,
    required List<Map<String, dynamic>> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900)),
        ),
        GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            final product = list[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        product['image'] as String,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(product['name'] as String,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('${product['price']} SYP',
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
