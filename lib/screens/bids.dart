import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dostrobajar/components/appbar.dart';
import 'package:dostrobajar/services/product.dart';

class BidsPage extends StatefulWidget {
  final Product product;

  const BidsPage({super.key, required this.product});

  @override
  createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Map<String, dynamic>> bids = [];

  @override
  void initState() {
    super.initState();
    _loadBids();
  }

  Future<void> _loadBids() async {
    try {
      final response = await supabase
          .from('product-bids')
          .select('''
            *,
            products(*)
          ''')
          .eq('product_id', widget.product.id.toString())
          .order('created_at', ascending: false);
      print("completed first stage.");
      final bidsResponse = await supabase
          .from('product-bids')
          .select('bidder_uid')
          .eq('product_id', widget.product.id.toString())
          .count();

      print("completed second stage.");

      print('Bids: ${response.length}');
      if (mounted) {
        setState(() {
          bids = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error loading bids: $e'),
              duration: const Duration(minutes: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context,
        title: "Bids",
        isHome: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bids.isEmpty
              ? const Center(
                  child: Text(
                    'No bids yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBids,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bids.length,
                    itemBuilder: (context, index) {
                      final bid = bids[index];
                      final bidder = bid['profiles'] as Map<String, dynamic>? ??
                          {'full_name': 'Anonymous', 'avatar_url': null};
                      final createdAt = DateTime.parse(bid['created_at']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: bidder['avatar_url'] != null
                                    ? NetworkImage(bidder['avatar_url'])
                                    : null,
                                child: bidder['avatar_url'] == null
                                    ? Text((bidder['full_name'] ?? 'A')[0]
                                        .toString()
                                        .toUpperCase())
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bidder['full_name'] ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Bid Amount: \$${bid['price']}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${bid['quantity']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      'Placed on: ${createdAt.toString().substring(0, 16)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
