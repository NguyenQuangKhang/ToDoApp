import 'package:flutter/material.dart';


import 'custom_button.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  CustomModalActionButton({required this.onClose, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButton(
          onPressed: onClose,
          buttonText: "Close",
          color: Colors.redAccent,
          textColor: Colors.white,
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: "Save",
          color: Colors.redAccent,
          textColor: Colors.white,
        )
      ],
    );
  }
}