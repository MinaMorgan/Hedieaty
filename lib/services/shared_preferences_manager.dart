import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();
  factory SharedPreferencesManager() => _instance;
  SharedPreferencesManager._internal();

  // Keys for storing preferences
  static const String _userIdKey = 'userId';
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _photoUrlKey = 'photoURL';

  // Save user details
  Future<void> saveUserDetails(Map<String, dynamic> userDetails) async {
    final prefs = await SharedPreferences.getInstance();

    // Ensure keys exist in the provided map
    if (userDetails.containsKey('userId')) {
      await prefs.setString(_userIdKey, userDetails['userId']);
    }
    if (userDetails.containsKey('name')) {
      await prefs.setString(_nameKey, userDetails['name']);
    }
    if (userDetails.containsKey('email')) {
      await prefs.setString(_emailKey, userDetails['email']);
    }
    if (userDetails.containsKey('phoneNumber')) {
      await prefs.setString(_phoneNumberKey, userDetails['phoneNumber']);
    }
    if (userDetails.containsKey('photoURL')) {
      await prefs.setString(_photoUrlKey, userDetails['photoURL']);
    }
  }

  // Get user details
  Future<Map<String, dynamic>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'userId': prefs.getString(_userIdKey) ?? '', // Provide default value
      'name': prefs.getString(_nameKey) ?? 'Unknown',
      'email': prefs.getString(_emailKey) ?? 'Unknown',
      'phoneNumber': prefs.getString(_phoneNumberKey) ?? 'Unknown',
      'photoURL': prefs.getString(_photoUrlKey) ??
          'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png',
    };
  }


  // Get ID
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey)!;
  }

  // Get Name
  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey)!;
  }

  // Get Email
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey)!;
  }

  // Get Phone Number
  Future<String> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey)!;
  }

  // Get Photo URL
  Future<String> getPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoUrlKey)!;
  }

  // Clear all preferences
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
