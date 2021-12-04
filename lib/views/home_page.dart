// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:video_trim_cut/picker_service.dart';

import '../dialogs.dart';
import '../service_locator.dart';
import 'audio_player_view.dart';
import 'video_player_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Technique"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  child: const Text("Filmer une vidéo"),
                  onPressed: () async {
                    final result =
                        await sl<PickerService>().pickVideoFromCamera();
                    if (result != null) {
                      Dialogs.askToReadVideoAudio(context, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return VideoPlayerView(path: result.path);
                          }),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fichier introuvable")));
                    }
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("Importer une vidéo"),
                onPressed: () async {
                  final result =
                      await sl<PickerService>().pickVideoFromGallery();
                  if (result != null) {
                    Dialogs.askToReadVideoAudio(context, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return VideoPlayerView(path: result.path);
                        }),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fichier introuvable")));
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("Couper une vidéo"),
                onPressed: () => Dialogs.uploadFile(context),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("Importer une musique"),
                onPressed: () async {
                  final result =
                      await sl<PickerService>().pickAudioFromGallery();
                  if (result != null) {
                    Dialogs.askToReadVideoAudio(context, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return AudioPlayerView(path: result.path);
                        }),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fichier introuvable")));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
