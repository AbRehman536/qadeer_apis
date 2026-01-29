import 'package:flutter/cupertino.dart';
import 'package:qadeer_apis/models/user.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  String? _token;

  ///set User
  void setUser(UserModel userModel){
    _userModel = userModel;
    notifyListeners();
  }
  ///set Token
  void setToken(String token){
    _token = token;
    notifyListeners();
  }

  ///get User
  UserModel? getUser() => _userModel;
  ///get Token
  String? getToken() => _token;
}