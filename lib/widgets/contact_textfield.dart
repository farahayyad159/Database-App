import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactTextField extends StatelessWidget {
  const ContactTextField({
    Key? key,
    required this.label,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    required this.controller,
  }) : super(key: key);

  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(color: Colors.blue),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({Color color= Colors.grey}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
      );
  }
}
