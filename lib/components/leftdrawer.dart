import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Drawer returnLeftDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade500,
                Colors.blue.shade600,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/pic.gif',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'John Doe',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'john.doe@example.com',
                style: GoogleFonts.lato(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.favorite_outline,
                  title: 'Wishlist',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  title: 'Shipping Address',
                  onTap: () => Navigator.pop(context),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Divider(height: 1, color: Colors.grey.shade300),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => Navigator.pop(context),
                isLogout: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isLogout = false,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: isLogout ? Colors.red : Colors.grey.shade700,
      size: 22,
    ),
    title: Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isLogout ? Colors.red : Colors.grey.shade800,
      ),
    ),
    dense: true,
    horizontalTitleGap: 0,
    onTap: onTap,
  );
}
