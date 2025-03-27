import 'package:flutter_bloc/flutter_bloc.dart';

part 'webview_state.dart';

enum WebViewStatus { loading, loaded, error }

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewState(status: WebViewStatus.loading));

  void setLoading(int progress) => emit(state.copyWith(status: WebViewStatus.loading, progress: progress));
  void setLoaded() => emit(state.copyWith(status: WebViewStatus.loaded, progress: 100));
  void setError() => emit(state.copyWith(status: WebViewStatus.error));
}