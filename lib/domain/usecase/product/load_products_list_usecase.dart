import 'package:challenges/data/models/product_model.dart';
import 'package:challenges/domain/repository/product/api_services_repository.dart';

class LoadProductsListUsecase{
  final ApiServicesRepository repository;

  LoadProductsListUsecase({required this.repository});

  Future<List<Product>> call(){
    return repository.loadProductList();
  }
}