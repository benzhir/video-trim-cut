import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  log(appDocumentDir.path.toString());
  final localDatabase = await databaseFactoryIo
      .openDatabase(join(appDocumentDir.path, 'record_videos.db'));

  sl.registerLazySingleton(() => localDatabase);
}
