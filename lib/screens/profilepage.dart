import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+977 9812345678',
    'address': 'Kathmandu, Nepal',
    'listings': 15,
    'views': 234,
    'likes': 56,
    'comments': 28,
  };

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 16),
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/pic.gif',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    userData['name'],
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard('Listings',
                          userData['listings'].toString(), Icons.list_alt),
                      _buildStatCard('Views', userData['views'].toString(),
                          Icons.visibility),
                      _buildStatCard('Likes', userData['likes'].toString(),
                          Icons.favorite),
                      _buildStatCard('Comments',
                          userData['comments'].toString(), Icons.comment),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Contact Information',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    child: Column(
                      children: [
                        _buildInfoTile(
                            'Email', userData['email'], Icons.email_outlined),
                        Divider(),
                        _buildInfoTile(
                            'Phone', userData['phone'], Icons.phone_outlined),
                        Divider(),
                        _buildInfoTile('Address', userData['address'],
                            Icons.location_on_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
