import 'package:dostrobajar/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:dostrobajar/services/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaceBidPage extends StatefulWidget {
  final Product product;
  const PlaceBidPage({super.key, required this.product});

  @override
  createState() => _PlaceBidPageState();
}

class _PlaceBidPageState extends State<PlaceBidPage> {
  final _formKey = GlobalKey<FormState>();
  final _bidAmountController = TextEditingController();
  final _quantityController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  double _totalBidAmount = 0;

  void _calculateTotal() {
    final price = double.tryParse(_bidAmountController.text) ?? 0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    setState(() {
      _totalBidAmount = price * quantity;
    });
  }

  Future<void> _placeBid() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bidAmount = int.parse(_bidAmountController.text);
      final quantity = int.parse(_quantityController.text);
      final userId = supabase.auth.currentUser!.id;
      String? firstname = await Supabase
          .instance.client.auth.currentUser?.userMetadata?['first_name'];
      String? lastname = await Supabase
          .instance.client.auth.currentUser?.userMetadata?['last_name'];
      String ownerName = '$firstname $lastname';

      await supabase.from('product-bids').insert({
        'product_id': widget.product.id,
        'bidder_uid': userId,
        'bidder_name': ownerName,
        'price': bidAmount,
        'quantity': quantity,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bid placed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing bid: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context,
        title: "Place Bid",
        isHome: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Current Price: \$${widget.product.price}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Bid Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bidAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your bid amount',
                ),
                onChanged: (_) => _calculateTotal(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bid amount';
                  }
                  final bid = double.tryParse(value);
                  if (bid == null) {
                    return 'Please enter a valid amount';
                  }
                  if (bid < widget.product.price) {
                    return 'Bid must be higher or equal to current price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter quantity',
                ),
                onChanged: (_) => _calculateTotal(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null) {
                    return 'Please enter a valid number';
                  }
                  if (quantity <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  if (quantity > widget.product.quantity) {
                    return 'Quantity exceeds available stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Bid Amount:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_totalBidAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeBid,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Place Bid',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
