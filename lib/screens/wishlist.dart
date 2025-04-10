import 'package:dostrobajar/components/nolisting.dart';
import 'package:dostrobajar/components/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/pages.dart';
import '../provider/product_provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadBiddedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ProductProvider>(context, listen: false)
            .loadBiddedProducts();
      },
      child: Consumer<ProductProvider>(builder: (context, provider, child) {
        if (provider.biddedProductsList.isEmpty) {
          return EmptyListing(
              msg:
                  "No products found in your wishlist.\nTry bidding some products.");
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
                itemCount: provider.biddedProductsList.length,
                itemBuilder: (context, index) {
                  final product = provider.biddedProductsList[index];
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
                          "ownerName": product.ownerName,
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
