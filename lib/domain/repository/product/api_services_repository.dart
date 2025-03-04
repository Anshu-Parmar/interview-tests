import 'package:challenges/data/models/product_model.dart';

abstract class ApiServicesRepository {
  Future<List<Product>> loadProductList();
}