import 'package:flutter/material.dart';
import 'package:flutter_bloc_login/feature/login/model/login_response_model.dart';

class LoginDetailView extends StatelessWidget {
  final LoginResponseModel model;
  const LoginDetailView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.token ?? ''),
      ),
    );
  }
}
