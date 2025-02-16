import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<DialogAction>? actions;
  final bool isDismissible;
  final Widget? icon;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.isDismissible = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        content,
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        if (actions?.isEmpty ?? true)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!
                  .map(
                    (action) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        onPressed: action.onPressed,
                        style: TextButton.styleFrom(
                          foregroundColor: action.isDestructive
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          action.label,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  DialogAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });
}

void showCustomDialog(
  BuildContext context, {
  required String title,
  required String content,
  List<DialogAction>? actions,
  bool isDismissible = true,
  Widget? icon,
}) {
  showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) => CustomDialog(
      title: title,
      content: content,
      actions: actions,
      isDismissible: isDismissible,
      icon: icon,
    ),
  );
}
