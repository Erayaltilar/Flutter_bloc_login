import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_login/feature/login/model/login_requset_model.dart';
import 'package:flutter_bloc_login/feature/login/model/login_response_model.dart';
import 'package:flutter_bloc_login/feature/login/service/i_login_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  final ILoginService service;

  bool isLoadingFail = false;
  bool isLoading = false;

  bool isLoginFail = false;

  LoginCubit(this.formKey, this.emailController, this.passwordController,
      {required this.service})
      : super(LoginInitial());

  Future<void> postUserModel() async {
    if (formKey.currentState != null &&
        formKey.currentState!.validate() &&
        !isLoading) {
      changeLoadinView();
      final data = await service.postUserLogin(LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim()));
      if (data is LoginResponseModel) {
        emit(LoginComplete(data));
      }
      await Future.delayed(const Duration(seconds: 2));
      changeLoadinView();
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail));
    }
  }

  void changeLoadinView() {
    print("a");
    isLoading = !isLoading;
    emit(LoginLoadingState(isLoading));
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginComplete extends LoginState {
  final LoginResponseModel model;

  LoginComplete(this.model);
}

class LoginValidateState extends LoginState {
  final bool isValidate;
  LoginValidateState(this.isValidate);
}

class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState(this.isLoading);
}
