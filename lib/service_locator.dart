
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'picker_service.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {

  sl.registerFactory(() => PickerService(
        imagePicker: sl(),
      ));

  sl.registerLazySingleton(() => ImagePicker());
}
