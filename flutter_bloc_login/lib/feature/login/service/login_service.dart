import 'dart:io';

import 'package:flutter_bloc_login/feature/login/model/login_requset_model.dart';
import 'package:flutter_bloc_login/feature/login/model/login_response_model.dart';
import 'package:flutter_bloc_login/feature/login/service/i_login_service.dart';

class LoginService extends ILoginService {
  LoginService(super.dio);

  @override
  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model.toJson());

    if (response.statusCode == HttpStatus.ok) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
