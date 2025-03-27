import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeepLinkCubit extends Cubit<String?> {
  static const _streamInstance = EventChannel('http.startopreneur-launch.com/events');
  static const _platform = MethodChannel('http.startopreneur-launch.com/channel');

  DeepLinkCubit() : super(null) {
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    // Listen for deep links while app is open
    _streamInstance.receiveBroadcastStream().listen((uri) => emit(uri));
    // Check if the app started via deep link
    String? initialUri = await _getInitialUri();
    if (initialUri != null) {
      emit(initialUri);
    }
  }

  Future<String?> _getInitialUri() async {
    try {
      return await _platform.invokeMethod('initialLink');
    } on PlatformException catch (_) {
      return null;
    }
  }
}