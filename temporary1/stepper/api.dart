//SHARED PREFS
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenManager {
  static const String _tokenKey = "auth_token";
  static const String _expiryKey = "token_expiry";

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryString = prefs.getString(_expiryKey);

    if (token != null && expiryString != null) {
      final expiryDate = DateTime.parse(expiryString);
      if (DateTime.now().isBefore(expiryDate)) {
        return token; // Token is still valid
      }
    }
    return null; // Token expired or not found
  }

  // Save token with expiry
  static Future<void> saveToken(String token, int expiresInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(Duration(seconds: expiresInSeconds));
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expiryKey, expiryDate.toIso8601String());
  }

  // Clear token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
  }

  // Refresh token if expired
  static Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) return null;

    final response = await http.post(
      Uri.parse("https://your-api.com/new_token"), // Replace with actual API
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['token'];
      final expiresIn = data['expires_in'] ?? 3600; // Assume 1 hour if not given

      await saveToken(newToken, expiresIn);
      return newToken;
    } else {
      await clearToken();
      return null;
    }
  }
}

//SERVICE FILE
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class AuthService {
  Future<bool> login(String rawData) async {
    final response = await http.post(
      Uri.parse("https://your-api.com/login3"), // Replace with actual API
      headers: {
        "Content-Type": "text/plain",
        "Cache-Control": "no-cache",
      },
      body: rawData,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final expiresIn = data['expires_in'] ?? 3600; // Default to 1 hour

      await TokenManager.saveToken(token, expiresIn);
      return true;
    } else {
      return false;
    }
  }

  Future<http.Response> getData(String endpoint) async {
    String? token = await TokenManager.getToken();

    if (token == null) {
      token = await TokenManager.refreshToken();
      if (token == null) throw Exception("Session expired. Please log in again.");
    }

    final response = await http.get(
      Uri.parse("https://your-api.com/$endpoint"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response;
  }
}

//CUBIT
import 'package:bloc/bloc.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(LoginInitial());

  Future<void> login(String rawData) async {
    emit(LoginLoading());
    final success = await _authService.login(rawData);
    if (success) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure("Login failed"));
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await TokenManager.getToken();
    if (token != null) {
      emit(LoginSuccess());
    } else {
      emit(LoginInitial());
    }
  }
}

