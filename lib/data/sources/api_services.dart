import 'dart:convert' show json;
import 'dart:developer';

import 'package:challenges/core/source/api/urls.dart';
import 'package:http/http.dart' as http;
import 'package:challenges/data/models/product_model.dart';

abstract class ApiServices {
  Future<List<Product>> loadProductList();
}

class ApiServicesImpl implements ApiServices {
  @override
  Future<List<Product>> loadProductList() async {
    try {
      final response = await http.get(Uri.parse('https://${Urls.domain}/${Urls.data}?${Urls.limit}'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Product.fromJson(data)).toList();
      } else {
        return [];
      }

    } catch (e) {
      log("$e", name: "API");
      rethrow;
    }
  }
}