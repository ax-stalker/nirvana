import 'package:flutter/material.dart';

class myTextFormField extends StatelessWidget {
  myTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hint,
    this.max = 1,
    this.min = 1,
    this.keyboardType =TextInputType.text,
  });

  final TextEditingController controller;
  TextInputType keyboardType;
  String labelText,hint;
  int max , min;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration:  InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
        hintText: hint,
      ),
      maxLines: max,
      minLines: min,
      keyboardType: keyboardType,
    );
  }
}