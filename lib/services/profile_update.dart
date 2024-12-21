// profile_update.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdateService {
  static const String _baseUrl = "https://level-up-backend-9hpz.onrender.com";

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phoneNo,
    String? address,
    int? height, // Correctly using int? here
    File? profileImage,
    required BuildContext context,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No token found");
    }

    Uri url = Uri.parse('$_baseUrl/api/user/update_by_self');

    var request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token';

    if (name != null) request.fields['name'] = name;
    if (phoneNo != null) request.fields['phone_no'] = phoneNo;
    if (address != null) request.fields['address'] = address;
    if (height != null) request.fields['height'] = height.toString(); // Convert to string here

    if (profileImage != null) {
      var profilePic = await http.MultipartFile.fromPath(
        'file',
        profileImage.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(profilePic);
    }

    try {
      var response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return {"success": true, "message": "Profile updated successfully."};
      } else {
        return {"success": false, "message": res.body}; // Important: Return the error body
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}