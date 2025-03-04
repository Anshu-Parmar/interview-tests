import 'package:challenges/data/models/product_model.dart';
import 'package:challenges/domain/usecase/product/load_products_list_usecase.dart';
import 'package:challenges/service_locator.dart' show sl;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final response = await sl<LoadProductsListUsecase>().call();

    if (response.isNotEmpty) {
      emit(ProductLoaded(products: response));
    } else {
      emit(ProductError(msg: "404: not found"));
    }
  }
}
