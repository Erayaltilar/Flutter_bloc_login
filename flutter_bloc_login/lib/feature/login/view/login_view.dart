import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login/core/extensions/context_size.dart';
import 'package:flutter_bloc_login/feature/login/service/login_service.dart';
import 'package:flutter_bloc_login/feature/login/view/login_detail_view.dart';
import 'package:flutter_bloc_login/feature/login/view_model/login_cubit.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String baseUrl = 'https://reqres.in/api';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
          formKey, emailController, passwordController,
          service: LoginService(Dio(BaseOptions(baseUrl: baseUrl)))),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginComplete) {
            state.navigate(context);
          }
        },
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: buildAppBar(state),
      body: Form(
        key: formKey,
        autovalidateMode: state is LoginValidateState
            ? (state.isValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled)
            : AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFormFieldEmail(),
            SizedBox(height: context.height * 0.03),
            buildTextFormFieldPassword(),
            SizedBox(height: context.height * 0.03),
            buildElevatedButtonLogin(context),
          ],
        ),
      ),
    );
  }

  BlocConsumer<LoginCubit, LoginState> buildElevatedButtonLogin(
      BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // if (state is LoginComplete) {
        //   state.navigate(context);
        // }
      },
      builder: (context, state) {
        if (state is LoginLoadingState) {
          return const Card(
            child: Icon(Icons.check),
          );
        }
        return ElevatedButton(
          onPressed: context.watch<LoginCubit>().isLoading
              ? null
              : () async {
                  await context.read<LoginCubit>().postUserModel();
                },
          child: const Text('Login'),
        );
      },
    );
  }

  AppBar buildAppBar(state) {
    return AppBar(
      title: const Text('Cubit Login'),
      leading: Visibility(
        visible:
            state is LoginLoadingState, //context.watch<LoginCubit>().isLoading,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  TextFormField buildTextFormFieldPassword() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => (value ?? '').length > 6
          ? null
          : 'Password must be at least 5 characters long',
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
    );
  }

  TextFormField buildTextFormFieldEmail() {
    return TextFormField(
      controller: emailController,
      validator: (value) => (value ?? '').length > 6
          ? null
          : 'Email must be at least 5 characters long',
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
      ),
    );
  }
}

extension LoginCompleteExtension on LoginComplete {
  void navigate(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginDetailView(
              model: model,
            )));
  }
}
