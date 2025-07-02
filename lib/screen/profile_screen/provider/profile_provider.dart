import 'dart:io';

import 'package:e_commerce_flutter/models/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/data/data_provider.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';
import 'package:http_parser/http_parser.dart';

/// Key to cache avatar URL in GetStorage
const String AVATAR_KEY = 'AVATAR_URL';

class ProfileProvider extends ChangeNotifier {
  // ──────────────────────────────────────────────────────────
  // Dependencies
  final DataProvider _dataProvider;
  final box = GetStorage();

  // ──────────────────────────────────────────────────────────
  // Address form controllers
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final couponController = TextEditingController();

  // ──────────────────────────────────────────────────────────
  // Avatar state
  String? avatarUrl; // URL từ Cloudinary / server
  XFile? _pickedAvatar; // file tạm trước khi upload
  bool isUploading = false;

  ProfileProvider(this._dataProvider) {
    retrieveSavedAddress();
    _retrieveCachedAvatar();
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ ADDRESS – nguyên bản của bạn                          ║
  // ╚══════════════════════════════════════════════════════╝
  void storeAddress() {
    box
      ..write(PHONE_KEY, phoneController.text)
      ..write(STREET_KEY, streetController.text)
      ..write(CITY_KEY, cityController.text)
      ..write(STATE_KEY, stateController.text)
      ..write(POSTAL_CODE_KEY, postalCodeController.text)
      ..write(COUNTRY_KEY, countryController.text);

    SnackBarHelper.showSuccessSnackBar('Address stored successfully');
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ AVATAR – pick & preview                              ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> pickAvatar({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    _pickedAvatar = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (_pickedAvatar == null) {
      SnackBarHelper.showErrorSnackBar('No image selected');
    }
    notifyListeners();
  }

  void cancelPickedAvatar() {
    _pickedAvatar = null;
    notifyListeners();
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ AVATAR – upload to server                            ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> uploadAvatar(String userId) async {
    if (_pickedAvatar == null) {
      SnackBarHelper.showErrorSnackBar('Please choose an image first');
      return;
    }

    isUploading = true;
    notifyListeners();

    try {
      final resp = await _dataProvider.uploadFile(
        endpointUrl: '/users/upload-avatar/$userId',
        fileField: 'avatar',
        filePath: _pickedAvatar!.path,
      );
      if (resp.success) {
        avatarUrl = resp.data['picture'];
        box.write(AVATAR_KEY, avatarUrl); // cache URL
        _pickedAvatar = null;
        SnackBarHelper.showSuccessSnackBar('Avatar updated');
      } else {
        SnackBarHelper.showErrorSnackBar(resp.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Upload failed: $e');
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  // ╔══════════════════════════════════════════════════════╗
  // ║ AVATAR – fetch profile from API                      ║
  // ╚══════════════════════════════════════════════════════╝
  Future<void> fetchProfile(String userId) async {
    try {
      final response =
          await _dataProvider.service.getItems(endpointUrl: 'users/$userId');

      if (response.isOk) {
        final jsonBody = response.body as Map<String, dynamic>;
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          (json) => json as Map<String, dynamic>,
        );

        avatarUrl = apiResponse.data?['picture'];
        if (avatarUrl != null) {
          box.write(AVATAR_KEY, avatarUrl);
          notifyListeners();
        }
      }
    } catch (_) {
      // offline? keep cached avatar
    }
  }

  Future<void> removeAvatar(String userId) async {
    try {
      // Nếu BE có endpoint xoá, gọi ở đây
      // await _dataProvider.service.deleteItems(endpointUrl: 'users/remove-avatar/$userId');
      avatarUrl = null;
      box.write(AVATAR_KEY, null);
      _pickedAvatar = null;
      notifyListeners();
      SnackBarHelper.showSuccessSnackBar('Avatar removed');
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Remove failed: $e');
    }
  }
  void _retrieveCachedAvatar() {
    avatarUrl = box.read(AVATAR_KEY);
  }

  bool get hasPickedAvatar => _pickedAvatar != null;
  File? get pickedAvatarFile =>
      _pickedAvatar != null ? File(_pickedAvatar!.path) : null;

  /// Manual UI refresh if you need it (similar to your original pattern)
  void updateUI() => notifyListeners();
}
