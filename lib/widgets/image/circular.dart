import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final BoxFit fit;

  CircularImage({@required this.image, @required this.size, this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: fit ?? BoxFit.cover,
          image: image,
        ),
      ),
    );
  }
}
