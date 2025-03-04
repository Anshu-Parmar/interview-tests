import 'package:challenges/data/repository/product/api_services_repository_impl.dart';
import 'package:challenges/data/sources/api_services.dart';
import 'package:challenges/domain/repository/product/api_services_repository.dart';
import 'package:challenges/domain/usecase/product/load_products_list_usecase.dart';
import 'package:get_it/get_it.dart' show GetIt;

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //SERVICES
  sl.registerSingleton<ApiServices>(ApiServicesImpl());

  //REPOSITORIES
  sl.registerSingleton<ApiServicesRepository>(ApiServicesRepositoryImpl());

  //USECASE
  sl.registerSingleton<LoadProductsListUsecase>(LoadProductsListUsecase(repository: sl.call()));
}