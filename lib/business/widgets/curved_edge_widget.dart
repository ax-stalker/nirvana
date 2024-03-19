// class curvedEdgeWidget extends sta
import 'package:flutter/material.dart';
import 'package:nirvana/business/widgets/curved_edges.dart';

class curvedEdgeWidget extends StatelessWidget {
  const curvedEdgeWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: customCurvedEdges(),
      child: child,
    );
  }
}