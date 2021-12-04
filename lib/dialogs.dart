import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'views/trimmer_view.dart';

class Dialogs {
  static askToReadVideoAudio(BuildContext context, Function onTapConfirm) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Voulez-vous lire la vidéo/l'audio ?",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: const Text(
            "Annuler",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          color: Colors.purple,
          child: const Text(
            "Lire",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            onTapConfirm();
          },
        ),
      ],
    ).show();
  }

  static uploadFile(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Importer depuis :",
      buttons: [
        DialogButton(
            child: const Text(
              "Caméra",
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
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fichier introuvable")));
              }
            },
            color: Colors.purple),
        DialogButton(
          child: const Text(
            "Galerie",
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fichier introuvable")));
            }
          },
          color: Colors.red,
        )
      ],
    ).show();
  }

  tt() {}
}
