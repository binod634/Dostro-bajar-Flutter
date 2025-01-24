import 'package:flutter/material.dart';

Widget productCard(BuildContext context,
    {required String image,
    required String name,
    required String price,
    required Function() onPressed,
    bool showWishlistBadge = false,
    bool isWishlist = false,
    Function()? onWishlistPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.2 * 255).round()),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (showWishlistBadge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlistPressed,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlist ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade600,
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
