import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_flutter/models/api_response.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:flutter_login/flutter_login.dart';
import '../../../models/auth_data.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/user.dart';
import '../login_screen.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utility/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider? _dataProvider;
  final box = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId:
        '360712972982-dcd9b4mt7fdpqnjh06aeinp69cj7evl8.apps.googleusercontent.com',
  );

  UserProvider(this._dataProvider);

  //login
  Future<String?> login(CustomLoginData data) async {
    try {
      Map<String, dynamic> loginData = {
        "email": data.email.toLowerCase(),
        "password": data.password,
      };

      final response = await service.addItem(
          endpointUrl: 'users/login', itemData: loginData);

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
          response.body,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          User? user = apiResponse.data;
          saveLoginInfo(user);
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Login Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to login: ${apiResponse.message}');
          return 'Failed to login: ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  //google login
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackBarHelper.showErrorSnackBar('Đăng nhập Google bị hủy.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final response = await service.addItem(
        endpointUrl: 'users/google',
        itemData: {'idToken': idToken},
      );

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
            response.body,
            (json) => User.fromJson(json as Map<String, dynamic>));

        if (apiResponse.success == true) {
          saveLoginInfo(apiResponse.data);
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Login with Google Success');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Google login failed: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Lỗi khi đăng nhập Google: $e');
    }
  }

  //register
  Future<String?> register(CustomSignupData data) async {
    try {
      Map<String, dynamic> userData = {
        "name": data.name,
        "email": data.email.toLowerCase(),
        "password": data.password,
      };

      final response = await service.addItem(
        endpointUrl: 'users/register',
        itemData: userData,
      );

      if (response.isOk) {
        final apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Register Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to register: ${apiResponse.message}');
          return 'Failed to register: ${apiResponse.message}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
        return 'Error ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      return 'An error occurred: $e';
    }
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    User? userLogged = User.fromJson(userJson ?? {});
    return userLogged;
  }

  logOutUser() {
    box.remove(USER_INFO_BOX);
    Get.offAll(LoginScreen());
  }
}