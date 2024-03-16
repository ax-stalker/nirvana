import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          Row(
            children: [
              // user , time
              Text(user, style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary)),
              Text(" . ", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              Text(time, style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary)),
            ],
          ),
        ],
      ),
    );
  }
}
