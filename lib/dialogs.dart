import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:video_trim_cut/trimmer_view.dart';

class Dialogs {
  static uploadFile(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "UPLOAD FROM",
      buttons: [
        DialogButton(
            child: const Text(
              "CAMERA",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final result = await ImagePicker().pickVideo(
                source: ImageSource.camera,
              );
              if (result != null) {
                File file = File(result.path);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(file);
                  }),
                );
              }
            },
            color: Colors.purple),
        DialogButton(
          child: const Text(
            "GALLERY",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);

            final result = await ImagePicker().pickVideo(
              source: ImageSource.gallery,
            );
            if (result != null) {
              File file = File(result.path);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return TrimmerView(file);
                }),
              );
            }
          },
          color: Colors.red,
        )
      ],
    ).show();
  }

  tt() {}
}
