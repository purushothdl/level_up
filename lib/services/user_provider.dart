import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _userData = {};

  // Getter to access user data
  Map<String, dynamic> get userData => _userData;

  // Setter to update user data and notify listeners
  void setUserData(Map<String, dynamic> newData) {
    _userData = newData;
    notifyListeners(); // Notify all listeners that the data has changed
  }

  // Method to clear user data
  void clearUserData() {
    _userData = {};
    notifyListeners(); // Notify listeners of the cleared data
  }
}
