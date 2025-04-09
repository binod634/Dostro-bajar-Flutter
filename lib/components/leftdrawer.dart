import 'package:cached_network_image/cached_network_image.dart';
import 'package:dostrobajar/components/dialog.dart';
import 'package:dostrobajar/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/pages.dart';
import '../services/userdata.dart';

Drawer returnLeftDrawer(BuildContext context) {
  return Drawer(
    child: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      final Userdata userdata = profileProvider.userdata;
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ]),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userdata.imageUrl.replaceAll(' ', ''),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        print(error);
                        return Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${userdata.firstName} ${userdata.lastName}',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userdata?.email ??
                      Supabase.instance.client.auth.currentUser?.email ??
                      '',
                  style: GoogleFonts.lato(
                    color: Colors.white.withAlpha(200),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 12),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.shopping_bag_rounded,
                    title: 'My Products',
                    onTap: () => {
                      Navigator.of(context).pushNamed(Routes.warehouse),
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.favorite_rounded,
                    title: 'Wishlist',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_rounded,
                    title: 'My Profile',
                    onTap: () => Navigator.pop(context),
                  ),
                  Divider(
                      height: 24, thickness: 1, color: Colors.grey.shade200),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_rounded,
                    title: 'About Us',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.help_rounded,
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
                Divider(height: 1, color: Colors.grey.shade200),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  onTap: () => {
                    showCustomDialog(context,
                        title: 'Logout',
                        content: 'Are you sure you want to logout?',
                        actions: [
                          DialogAction(
                              label: 'Yes',
                              isDestructive: true,
                              onPressed: () => {
                                    Supabase.instance.client.auth.signOut(),
                                    Navigator.pop(context)
                                  }),
                          DialogAction(
                            label: 'No',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      );
    }),
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
      color: isLogout ? Colors.red.shade400 : Colors.grey.shade700,
      size: 26,
    ),
    title: Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isLogout ? Colors.red.shade400 : Colors.grey.shade800,
      ),
    ),
    dense: true,
    onTap: onTap,
  );
}
