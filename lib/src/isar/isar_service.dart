import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/users/user.dart';

class IsarService {
  static Future<Isar> getDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.open(
        [ProfileSchema, UserSchema],
        directory: dir.path,
        inspector: true,
      );
    } else {
      return Future.value(Isar.getInstance()!);
    }
  }
}
