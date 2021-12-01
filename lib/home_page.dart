
import 'package:flutter/material.dart';

import 'dialogs.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Trimmer"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("LOAD VIDEO"),
          onPressed: () => Dialogs.uploadFile(context),
        ),
      ),
    );
  }
}
