import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';

import '../utility/constants.dart';

class HttpService {
  String get baseUrl => kIsWeb
      ? 'http://localhost:3000'
      : Platform.isAndroid
          ? 'http://10.0.2.2:3000'
          : 'http://localhost:3000';

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      return await GetConnect().get('$baseUrl/$endpointUrl');
    } catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final response =
          await GetConnect().post('$baseUrl/$endpointUrl', itemData);
      print(response.body);
      return response;
    } catch (e) {
      print('Error: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      return await GetConnect().put('$baseUrl/$endpointUrl/$itemId', itemData);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      return await GetConnect().delete('$baseUrl/$endpointUrl/$itemId');
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
  
}
