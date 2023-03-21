import 'dart:io';

import 'package:camera/camera/image_view.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


ValueNotifier<List> db = ValueNotifier([]);

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camera',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: db,
          builder: (context, List data, text) {
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 30,
              ),
              children: List.generate(
                data.length,
                (index) {
                  return GestureDetector(
                    onTap: (() {
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ImageView(
                            image: data[index],
                          ),
                        ),
                      );
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(
                            File(
                              data[index].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromCamera();
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  ImagePicker picker = ImagePicker();

  getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
    // } else {
    //   final photoTemp = File(image.path);
    //   setState(
    //     () {
    //       image = photoTemp;
    //     },
    //   );
    // }

// ignore: must_be_immutable
  }

  getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    } else {
      Directory? directory = await getExternalStorageDirectory();
      File imagePath = File(image.path);
      await imagePath.copy('${directory!.path}/${DateTime.now()}.jpg');
      getItems(directory);
    }
  }

  getItems(Directory directory) async {
    final listDir = await directory.list().toList();
    db.value.clear();
    for (var i = 0; i < listDir.length; i++) {
      if (listDir[i].path.substring(
              (listDir[i].path.length - 4), (listDir[i].path.length)) ==
          '.jpg') {
        db.value.add(listDir[i].path);
        db.notifyListeners();
      }
    }
  }
}