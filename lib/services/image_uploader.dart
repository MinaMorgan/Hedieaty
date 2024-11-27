import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';

class ImageUploadService {
  final String clientId = '9a18d89687a9a58';

  Future<String?> uploadImageToImgur(File imageFile) async {
    final uri = Uri.parse('https://api.imgur.com/3/image');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Client-ID $clientId'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseData.body);
      return jsonResponse['data']
          ['link']; // This is the URL of the uploaded image
    } else {
      print('Failed to upload image: ${responseData.body}');
      return null;
    }
  }
}
