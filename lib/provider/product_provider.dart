import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:logging/logging.dart';

import '../services/product.dart';

class ProductProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Product> products = [];
  final _logger = Logger('ProductProvider');

  List<int> _biddedOn = <int>[];

  get biddedProductsList =>
      products.where((product) => _biddedOn.contains(product.id)).toList();

  Future<void> loadProducts() async {
    if (products.isNotEmpty) return;
    try {
      final response = await _supabase.from('products').select();

      products =
          (response as List).map((json) => Product.fromJson(json)).toList();

      notifyListeners();

      _logger.info("Got data $response");
    } catch (e) {
      _logger.severe('Error loading products: $e');
    }
  }

  Future<void> loadBiddedProducts() async {
    await loadProducts();
    try {
      final response = await _supabase
          .from("users")
          .select("bidded_on")
          .eq('email', _supabase.auth.currentUser?.email ?? "")
          .single();

      if (response != null && response['bidded_on'] != null) {
        _biddedOn =
            (response['bidded_on'] as List).map((item) => item as int).toList();
      }
      notifyListeners();
    } catch (e) {
      _logger.severe('Error loading bidded products: $e');
    }
  }

  Future<void> addProduct(Product product,
      {Uint8List? imageFile, String? imagePath}) async {
    try {
      String? imageUrl;
      if (imageFile != null && imagePath != null) {
        await _supabase.storage
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
      _logger.severe('Error adding product: $e');
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
      _logger.severe('Error removing product: $e');
    }
  }
}
