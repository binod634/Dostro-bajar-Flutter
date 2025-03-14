import 'package:dostrobajar/components/appbar.dart';
import 'package:dostrobajar/components/dialog.dart';
import 'package:dostrobajar/components/nolisting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/pages.dart';
import '../provider/product_provider.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, onLeadingPressed: () {
        Navigator.pop(context);
      }, isHome: false, title: "My Products"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.addProductPAge);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isEmpty) {
            return const EmptyListing();
          }
          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.productProfile,
                      arguments: {
                        "id": product.id,
                        "name": product.name,
                        "image": product.imageUrl,
                        "price": product.price,
                        "description": product.description,
                        "quantity": product.quantity,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'product_image_${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 16,
                                      color: Colors.blue[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Stock: ${product.quantity}',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (product.description.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {
                                // Handle edit
                              },
                              color: Colors.blue[700],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                showCustomDialog(context,
                                    title: 'Delete Product',
                                    content:
                                        'Are you sure you want to delete this product?',
                                    actions: [
                                      DialogAction(
                                          label: 'Cancel',
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                      DialogAction(
                                          label: 'Delete',
                                          isDestructive: true,
                                          onPressed: () {
                                            provider.removeProduct(product);
                                            Navigator.pop(context);
                                          }),
                                    ],
                                    isDismissible: true,
                                    icon: Icon(Icons.delete_outline_sharp));
                              },
                              color: Colors.red[400],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
