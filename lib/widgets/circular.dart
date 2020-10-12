import 'package:flutter/material.dart';

Widget CircularImage(
        {@required ImageProvider image, @required double size, BoxFit fit}) =>
    Container(
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
