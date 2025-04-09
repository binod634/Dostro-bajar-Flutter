import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../components/appbar.dart';
import '../provider/product_provider.dart';
import '../services/product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _imagePath = 'product_${DateTime.now().millisecondsSinceEpoch}.png';
      });
    }
  }

  void _addProduct() async {
    if (!mounted) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isloading = true;
    });

    String? uuid = Supabase.instance.client.auth.currentUser?.id;
    String? firstname = await Supabase
        .instance.client.auth.currentUser?.userMetadata?['first_name'];
    String? lastname = await Supabase
        .instance.client.auth.currentUser?.userMetadata?['last_name'];
    String ownerName = '$firstname $lastname';

    try {
      if (!mounted) return;

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      var product = Product(
        ownerName: ownerName,
        name: _nameController.text,
        uuid: uuid,
        price: int.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        description: _descriptionController.text,
        imageUrl: '',
      );

      if (!mounted) return;

      await Provider.of<ProductProvider>(context, listen: false).addProduct(
          product,
          imageFile: _selectedImageBytes,
          imagePath: _imagePath);

      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      navigator.pop();

      setState(() {
        isloading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context,
        title: 'Add New Product',
        isHome: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _selectedImageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: _imageUrlController.text.isNotEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isloading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isloading
                      ? CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 5)
                      : Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
