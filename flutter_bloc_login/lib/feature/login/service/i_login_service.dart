import 'package:dio/dio.dart';
import 'package:flutter_bloc_login/feature/login/model/login_requset_model.dart';
import 'package:flutter_bloc_login/feature/login/model/login_response_model.dart';

abstract class ILoginService {
  final Dio dio;
  ILoginService(this.dio);

  final String loginPath = ILoginServicePath.login.rawValue;
  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model);
}

enum ILoginServicePath { login }

extension ILoginServicePathExtension on ILoginServicePath {
  String get rawValue {
    switch (this) {
      case ILoginServicePath.login:
        return '/login';
    }
  }
}
