import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/login_cubit.dart';
import 'package:flutter_practice/cubit/states/login_state.dart';
import 'package:flutter_practice/ui/pages/text_to_speach_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/constants.dart';
import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  final LoginCubit cubit = LoginCubit();
  final _loginTextFieldController = TextEditingController();
  final _passwordTexFieldController = TextEditingController();

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    final prefferences = await SharedPreferences.getInstance();
    final savedEmail =
        prefferences.getString(Constants.autoLoginEmailPreffName);

    if (savedEmail != null) {
      var isLoginSuccessful = await cubit.loginByEmail(savedEmail);

      if (isLoginSuccessful) {
        Get.to(const TextToSpeachPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('loginToYourAccount'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: _loginPageConsumerListener,
            bloc: cubit,
            builder: _loginPageConsumerBuilder,
          ),
        ),
      );

  Widget _loginPageConsumerBuilder(BuildContext context, LoginState state) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _loginTextFieldController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'email'.tr,
              hintStyle: const TextStyle(color: Colors.black54),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordTexFieldController,
            obscureText: state.shouldHidePassword,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                    state.shouldHidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.deepPurpleAccent),
                onPressed: () => _onHidePasswordPressed(state),
              ),
              hintText: 'password'.tr,
              hintStyle: const TextStyle(color: Colors.black54),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                  activeColor: Colors.deepPurple,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  side: const BorderSide(color: Colors.deepPurple, width: 2),
                  value: state.shouldRememberLogin,
                  onChanged: _onRememberMeChecked),
              Text('rememberMe'.tr),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: Text('login'.tr),
          ),
          ElevatedButton(
            onPressed: _onCreateAccountPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: Text('createAnAccount'.tr),
          ),
        ],
      );

  void _loginPageConsumerListener(
      BuildContext context, LoginState state) async {
    if (state.isloginSuccessful) {
      final prefferences = await SharedPreferences.getInstance();

      prefferences.setString(
          Constants.autoLoginEmailPreffName, _loginTextFieldController.text);

      await Get.to(const TextToSpeachPage());

      _loginTextFieldController.text = "";
      _passwordTexFieldController.text = "";
    } else if (state.errorText != null) {
      Get.snackbar('error'.tr, state.errorText!);
    }
  }

  void _onHidePasswordPressed(LoginState state) =>
      cubit.setShouldHidePassword(!state.shouldHidePassword);

  void _onRememberMeChecked(bool? checked) =>
      cubit.setShouldRememberLogin(checked!);

  void _onLoginPressed() => cubit.login(
      _loginTextFieldController.text, _passwordTexFieldController.text);

  void _onCreateAccountPressed() async {
    var navigationResult = await Get.to(const CreateAccountPage());

    if (navigationResult != null) {
      _loginTextFieldController.text = navigationResult;
    }
  }
}
