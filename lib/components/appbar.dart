import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar myAppBar(
  BuildContext context, {
  String title = "Boli Bazaar",
  bool isHome = true,
  required Function() onLeadingPressed,
}) {
  return AppBar(
    leading: Center(
      child: GestureDetector(
        onTap: onLeadingPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FaIcon(
            isHome ? Icons.menu : Icons.arrow_back,
            color: Colors.grey.shade700,
            size: 24,
          ),
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade800,
        letterSpacing: 0.5,
      ),
    ),
    actions: isHome
        ? [
            IconButton(
              icon: Stack(
                children: [
                  FaIcon(
                    FontAwesomeIcons.store,
                    color: Colors.grey.shade700,
                    size: 26,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                // TODO: Implement cart functionality
              },
            ),
            SizedBox(width: 8),
          ]
        : [],
  );
}
