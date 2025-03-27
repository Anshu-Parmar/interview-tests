part of 'webview_cubit.dart';

class WebViewState {
  final WebViewStatus status;
  final int progress;

  WebViewState({required this.status, this.progress = 0});

  WebViewState copyWith({WebViewStatus? status, int? progress}) {
    return WebViewState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}