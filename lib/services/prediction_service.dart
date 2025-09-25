import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/constants.dart';

class PredictionService {
  Future<Map<String, dynamic>> predictImage({
    required File imageFile,
    required String modelId,
  }) async {
    final uri = Uri.parse('$serverUrl/predict/$modelId');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception("Error: ${response.reasonPhrase} ($responseBody)");
    }
  }
}