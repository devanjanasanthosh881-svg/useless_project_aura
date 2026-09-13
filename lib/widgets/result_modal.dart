import 'package:flutter/material.dart';

class ResultModal extends StatelessWidget {
  final String imageAssetPath;
  const ResultModal({super.key, required this.imageAssetPath});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text(
        "Photo Successfully Ruined",
        style: TextStyle(color: Colors.redAccent),
      ),
      content: Image.asset(imageAssetPath),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
