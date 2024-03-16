import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        child: const Icon(Icons.cancel, color:Colors.red);
      }
    );
  }
}