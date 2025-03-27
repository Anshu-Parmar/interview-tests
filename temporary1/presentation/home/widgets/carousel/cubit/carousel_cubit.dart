import 'package:flutter_bloc/flutter_bloc.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit() : super(CarouselState(selectedIndex: 0));

  nextCarouselPage (int index) {
    emit(CarouselState(selectedIndex: index));
  }
}
