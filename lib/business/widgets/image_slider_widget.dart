import 'package:flutter/material.dart';
import 'package:nirvana/business/widgets/curved_edge_widget.dart';

class image_slider extends StatelessWidget {
  const image_slider({
    super.key,
    required this.urli,
  });

  final String urli;

  @override
  Widget build(BuildContext context) {
    return curvedEdgeWidget(
      child: 
    Container(
      color: Colors.blueGrey,
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            // padding: EdgeInsets.all(32)
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.network(urli,
              fit: BoxFit.cover,
              ),
            ),
            
          ),
          AppBar(leading: IconButton(onPressed:() {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios)),
           backgroundColor: Colors.transparent,)
        ],
      ),
    )
      );
  }
}