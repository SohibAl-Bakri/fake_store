import 'dart:convert';
import 'dart:developer';
import 'package:fake_store/model/users_model.dart';
import 'package:http/http.dart' as http;
import '../model/categories_model.dart';
import '../model/products_model.dart';

class ApiHandler {
  static Future<List<dynamic>> getData({required String target}) async {
    try {
      Uri uri = Uri.https('api.escuelajs.co', '/api/v1/$target');

      http.Response response = await http.get(uri);
      // print(response.body);
      // print('response is : ${jsonDecode(response.body)} ');
      if (target == 'products') {
        final data = jsonDecode(response.body);
        List<ProductsModel> products = [];

        for (var item in data) {
          //print('item is : $item');
          products.add(ProductsModel.fromJson(item));
        }
        return products;
      }
      if (target == 'categories') {
        final data = jsonDecode(response.body);
        List<CategoriesModel> categories = [];

        for (var item in data) {
          //print('item is : $item');
          categories.add(CategoriesModel.fromJson(item));
        }
        return categories;
      }
      if (target == 'users') {
        final data = jsonDecode(response.body);
        List<UsersModel> users = [];

        for (var item in data) {
          //print('item is : $item');
          users.add(UsersModel.fromJson(item));
        }
        return users;
      }
      return [];
    } catch (error) {
      log('Error: $error');
      throw error.toString();
    }
  }

  static Future<List<ProductsModel>> getAllProduct() async {
    List products = await getData(target: 'products');
    return products as List<ProductsModel>;
  }

  static Future<List<CategoriesModel>> getAllCategories() async {
    List categories = await getData(target: 'categories');
    return categories as List<CategoriesModel>;
  }

  static Future<List<UsersModel>> getAllUsers() async {
    List users = await getData(target: 'users');
    return users as List<UsersModel>;
  }

  static Future<ProductsModel> getProductsPyId({required String id}) async {
    try {
      Uri uri = Uri.https('api.escuelajs.co', '/api/v1/products/$id');

      http.Response response = await http.get(uri);
      final data = jsonDecode(response.body);
      return ProductsModel.fromJson(data);
    } catch (error) {
      log('Error: $error');
      throw error.toString();
    }
  }
}
