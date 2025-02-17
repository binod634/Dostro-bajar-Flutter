import 'package:dostrobajar/components/nolisting.dart';
import 'package:dostrobajar/components/product.dart';
import 'package:dostrobajar/services/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/pages.dart';
import '../provider/product_provider.dart';

class EcommercePage extends StatefulWidget {
  const EcommercePage({super.key});

  @override
  createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ProductProvider>(context, listen: false)
            .loadProducts();
      },
      child: Consumer<ProductProvider>(builder: (context, provider, child) {
        if (provider.products.isEmpty) {
          return const EmptyListing();
        }

        return SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return productCard(
                    context,
                    name: product.name,
                    image: product.imageUrl,
                    price: product.price.toString(),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.productProfile,
                        arguments: {
                          "name": product.name,
                          "image": product.imageUrl,
                          "price": product.price,
                          "id": product.id,
                          "description": product.description,
                          "quantity": product.quantity,
                        },
                      );
                    },
                  );
                },
              )),
        );
      }),
    );
  }
}
