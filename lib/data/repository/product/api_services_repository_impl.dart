import 'package:challenges/data/models/product_model.dart';
import 'package:challenges/data/sources/api_services.dart' show ApiServices;
import 'package:challenges/domain/repository/product/api_services_repository.dart';
import 'package:challenges/service_locator.dart' show sl;

class ApiServicesRepositoryImpl implements ApiServicesRepository{
  @override
  Future<List<Product>> loadProductList() async {
    return await sl<ApiServices>().loadProductList();
  }
}