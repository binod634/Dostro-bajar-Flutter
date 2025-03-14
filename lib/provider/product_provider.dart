import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

import '../services/product.dart';

class ProductProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Product> products = [];

  Future<void> loadProducts() async {
    try {
      final response = await _supabase.from('products').select();

      products =
          (response as List).map((json) => Product.fromJson(json)).toList();

      notifyListeners();

      print("Got datas $response");
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> addProduct(Product product,
      {Uint8List? imageFile, String? imagePath}) async {
    try {
      String? imageUrl;
      if (imageFile != null && imagePath != null) {
        final storageResponse = await _supabase.storage
            .from('product-images')
            .uploadBinary(imagePath, imageFile);

        imageUrl =
            _supabase.storage.from('product-images').getPublicUrl(imagePath);

        product.imageUrl = imageUrl;
      } else {
        product.imageUrl = '';
      }

      final response =
          await _supabase.from('products').insert(product.toJson()).select();
      product.id = response.first['id'];
      products.add(product);
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      final imagePathRegExp = RegExp(r'product-images/(.+)');
      final match = imagePathRegExp.firstMatch(product.imageUrl);
      if (match != null) {
        final imagePath = match.group(1);
        await _supabase.storage.from('product-images').remove([imagePath!]);
      }
    
      await _supabase.from('products').delete().eq('id', product.id!);

      products.remove(product);
      notifyListeners();
    } catch (e) {
      print('Error removing product: $e');
    }
  }
}
