import 'package:dostrobajar/components/nolisting.dart';
import 'package:dostrobajar/components/product.dart';
import 'package:flutter/material.dart';

class EcommercePage extends StatefulWidget {
  const EcommercePage({super.key});

  @override
  createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  final List<Map<String, dynamic>> _items = List.generate(
      25,
      (index) => {
            "id": index,
            "name": "Product ${index + 1}",
            "price": (15.99 + index).toStringAsFixed(2),
            "image": "https://picsum.photos/400?random=$index"
          });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: _items.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return productCard(context,
                    name: _items[index]['name'],
                    image: _items[index]['image'],
                    price: _items[index]['price'], onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/product-profile',
                    arguments: {
                      "name": _items[index]['name'],
                      "image": _items[index]['image'],
                      "price": _items[index]['price']
                    },
                  );
                });
              },
            )
          : EmptyListing(),
    );
  }
}
