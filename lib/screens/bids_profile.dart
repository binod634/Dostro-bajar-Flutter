import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/appbar.dart';
import '../services/product.dart';

class BidsProfile extends StatefulWidget {
  final Map<String, dynamic> bid;

  const BidsProfile({super.key, required this.bid});

  @override
  createState() => _BidsProfileState();
}

class _BidsProfileState extends State<BidsProfile> {
  void showContactsDialog(BuildContext context, String? emailAddress) {
    var supabase = Supabase.instance.client;
    supabase
        .from('users')
        .select()
        .eq('email', emailAddress ?? '')
        .single()
        .then(
      (value) {
        print("value is $value");
        print("isphone is ${value['phoneNumber'] ?? ''}");
        String name =
            '${value['firstName'] ?? ''} ${value['lastName'] ?? ''}'.trim();
        String phone = value['phoneNumber'].toString();
        String email = value['email'] ?? '';

        if (name.isEmpty && phone.isEmpty && email.isEmpty) {
          print("REALLY >>>>");
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text("Can't find contact details"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'))
                    ],
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name.isNotEmpty) Text('Name: $name'),
                        if (phone.isNotEmpty) Text('Phone: $phone'),
                        if (email.isNotEmpty) Text('Email: $email'),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'))
                    ],
                  ));
        }
      },
    ).onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Contact Information'),
                content: Text(
                    "Can't find contact details. error: ${error.toString()}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'))
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bid = widget.bid;
    final createdAt = DateTime.parse(bid['created_at']);

    return Scaffold(
      appBar: myAppBar(
        context,
        title: "Bid Details",
        isHome: false,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bidder Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: bid['avatar_url'] != null
                            ? NetworkImage(bid['avatar_url'])
                            : null,
                        child: bid['avatar_url'] == null
                            ? Text(
                                (bid['bidder_name'] ?? 'A')[0]
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 24),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bid['bidder_name'] ?? 'Anonymous',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Joined: ${createdAt.year}',
                              style: TextStyle(
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

              // Bid Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bid Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Bid Amount', '\$${bid['price']}'),
                      _buildDetailRow('Quantity', '${bid['quantity']} units'),
                      _buildDetailRow('Date',
                          '${createdAt.day}/${createdAt.month}/${createdAt.year}'),
                      _buildDetailRow('Time',
                          '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'),
                      if (bid['message'] != null && bid['message'].isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bid['message'],
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showContactsDialog(context, bid['bidder_email']);
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Contact Bidder'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
