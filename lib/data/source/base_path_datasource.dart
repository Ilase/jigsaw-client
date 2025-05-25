import 'package:shared_preferences/shared_preferences.dart';

class BasePathDataSource {
  Future<void> saveBasePath(Uri uri) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('base_path', uri.toString());
    print(uri.toString());
  }

  Future<Uri?> getBasePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getPath = prefs.getString('base_path');
    print(getPath.toString());

    if (getPath == null) return null;
    return Uri.tryParse(getPath);
  }
}
