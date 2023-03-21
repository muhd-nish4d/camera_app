import 'dart:io';

import 'package:camera/camera/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, this.image});
  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,        
      ),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: db,
        builder: (context, List data, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.file(
                File(
                  image.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}