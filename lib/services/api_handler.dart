import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/products_model.dart';

class ApiHandler {
  static Future<List<ProductsModel>> getAllProduct() async {
    Uri uri = Uri.https('api.escuelajs.co', '/api/v1/products');

    http.Response response = await http.get(uri);
    // print(response.body);
    // print('response is : ${jsonDecode(response.body)} ');

    final data = jsonDecode(response.body);
    List<ProductsModel> products = [];

    for (var item in data) {
      //print('item is : $item');
      products.add(ProductsModel.fromJson(item));
    }
    return products;
  }
}
