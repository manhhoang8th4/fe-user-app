import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/auth_data.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';
import '../login_screen.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider? _dataProvider;
  final box = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '360712972982-dcd9b4mt7fdpqnjh06aeinp69cj7evl8.apps.googleusercontent.com',
  );

  UserProvider(this._dataProvider);

  // login
  Future<String?> login(CustomLoginData data) async {
    try {
      Map<String, dynamic> loginData = {
        "email": data.email.toLowerCase(),
        "password": data.password,
      };

      final response = await service.addItem(
        endpointUrl: 'users/login',
        itemData: loginData,
      );

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
          response.body,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          User? user = apiResponse.data;
          saveLoginInfo(user);
          SnackBarHelper.showSuccessSnackBar(ez.tr(apiResponse.message));
          log('Login Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
            '${ez.tr('login.failed')}: ${ez.tr(apiResponse.message)}',
          );
          return '${ez.tr('login.failed')}: ${ez.tr(apiResponse.message)}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error ${ez.tr(response.body?['message']?.toString() ?? response.statusText ?? '')}',
        );
        return 'Error ${ez.tr(response.body?['message']?.toString() ?? response.statusText ?? '')}';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(ez.tr('error.general', args: [e.toString()]));
      return ez.tr('error.general', args: [e.toString()]);
    }
  }

  // login with Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackBarHelper.showErrorSnackBar(ez.tr('google_login.canceled'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final response = await service.addItem(
        endpointUrl: 'users/google',
        itemData: {'idToken': idToken},
      );

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
          response.body,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          saveLoginInfo(apiResponse.data);
          SnackBarHelper.showSuccessSnackBar(ez.tr(apiResponse.message));
          log('Login with Google Success');
        } else {
          SnackBarHelper.showErrorSnackBar(
            ez.tr('google_login.failed', args: [ez.tr(apiResponse.message)]),
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error ${ez.tr(response.body?['message']?.toString() ?? response.statusText ?? '')}',
        );
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(ez.tr('google_login.error', args: [e.toString()]));
    }
  }

  // register
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
          SnackBarHelper.showSuccessSnackBar(ez.tr(apiResponse.message));
          log('Register Success');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar(
            '${ez.tr('register.failed')}: ${ez.tr(apiResponse.message)}',
          );
          return '${ez.tr('register.failed')}: ${ez.tr(apiResponse.message)}';
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Error ${ez.tr(response.body?['message']?.toString() ?? response.statusText ?? '')}',
        );
        return 'Error ${ez.tr(response.body?['message']?.toString() ?? response.statusText ?? '')}';
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(ez.tr('error.general', args: [e.toString()]));
      return ez.tr('error.general', args: [e.toString()]);
    }
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    return User.fromJson(userJson ?? {});
  }

  void logOutUser() {
    box.remove(USER_INFO_BOX);
    Get.offAll(LoginScreen());
  }
}
