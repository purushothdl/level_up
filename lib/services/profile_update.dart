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
    String? occupation,
    String? address,
    int? age,
    int? height,
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

    // Add form fields if they're not null
    if (name != null) request.fields['name'] = name;
    if (phoneNo != null) request.fields['phone_no'] = phoneNo;
    if (address != null) request.fields['address'] = address;
    if (occupation != null) request.fields['occupation'] = occupation;
    if (age != null) request.fields['age'] = age.toString();
    if (height != null) request.fields['height'] = height.toString();

    // Add the profile image if it exists
    if (profileImage != null) {
      String fileExtension = profileImage.path.split('.').last;
      String mimeType = 'image/$fileExtension';  // Dynamically set mime type based on file extension

      // Debugging: Print image file path and mime type
      print('Image Path: ${profileImage.path}');
      print('Mime Type: $mimeType');

      var profilePic = await http.MultipartFile.fromPath(
        'file', 
        profileImage.path, 
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(profilePic);
    }

    try {
      // Send the request and get the response
      var response = await request.send();
      final res = await http.Response.fromStream(response);

      // Debugging: Log response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${res.body}');

      if (response.statusCode == 200) {
        return {"success": true, "message": "Profile updated successfully."};
      } else {
        return {"success": false, "message": res.body};  // Return error body for debugging
      }
    } catch (e) {
      // Handle any errors during the request
      return {"success": false, "message": e.toString()};
    }
  }
}
