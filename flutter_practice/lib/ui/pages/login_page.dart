import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/login_cubit.dart';
import 'package:flutter_practice/cubit/states/login_state.dart';
import 'package:flutter_practice/ui/pages/main_page.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  final _cubit = LoginCubit();
  final _loginTextFieldController = TextEditingController();
  final _passwordTexFieldController = TextEditingController();
  bool _shouldHidePassword = true;
  bool _shouldRememberLogin = false;
  bool _shouldShowLoader = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var isLoginSuccessful = await _cubit.tryLoginBySavedEmail();

    if (isLoginSuccessful) {
      Get.offAll(() => const MainPage());
    }
  }

  @override
  void dispose() {
    _loginTextFieldController.dispose();
    _passwordTexFieldController.dispose();
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundWhite,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 20),
          child: BlocListener<LoginCubit, LoginState>(
            listener: _loginPageConsumerListener,
            bloc: _cubit,
            child: Stack(children: [
              Visibility(
                  visible: _shouldShowLoader,
                  child: const Center(
                    child: LoadingIndicator(
                        colors: [AppColors.backgroundBlack],
                        indicatorType: Indicator.ballClipRotateMultiple),
                  )),
              Opacity(
                opacity: _shouldShowLoader ? 0.4 : 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('logIntoYourAccount'.tr,
                          style: const TextStyle(
                              color: AppColors.textBlack,
                              fontFamily: AppFonts.productSans,
                              fontSize: 24,
                              height: 2,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 70),
                    TextField(
                      controller: _loginTextFieldController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'emailAdress'.tr,
                        hintStyle: const TextStyle(
                            color: AppColors.disabledGrey,
                            fontFamily: AppFonts.productSans,
                            fontSize: 16),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.separatorGrey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.separatorGrey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _passwordTexFieldController,
                      obscureText: _shouldHidePassword,
                      keyboardType: _shouldHidePassword
                          ? TextInputType.text
                          : TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              _shouldHidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.iconGrey),
                          onPressed: _onHidePasswordPressed,
                        ),
                        hintText: 'password'.tr,
                        hintStyle: const TextStyle(
                            color: AppColors.disabledGrey,
                            fontFamily: AppFonts.productSans,
                            fontSize: 16),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.separatorGrey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.separatorGrey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                              activeColor: AppColors.backgroundBlack,
                              checkColor: AppColors.backgroundWhite,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: _shouldRememberLogin,
                              onChanged: _onRememberMeChecked),
                        ),
                        const SizedBox(width: 10),
                        Text('rememberMe'.tr,
                            style: const TextStyle(
                                color: AppColors.textBlack,
                                fontFamily: AppFonts.productSans,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.backgroundBlack,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      child: Text('logInCaps'.tr,
                          style: const TextStyle(
                              color: AppColors.backgroundWhite,
                              fontFamily: AppFonts.productSans,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('dontHaveAnAccount'.tr,
                            style: const TextStyle(
                                color: AppColors.textBlack,
                                fontFamily: AppFonts.productSans,
                                fontSize: 16)),
                        TextButton(
                            onPressed: _onCreateAccountPressed,
                            child: Text('signUp'.tr,
                                style: const TextStyle(
                                    color: AppColors.textBlack,
                                    decoration: TextDecoration.underline,
                                    fontFamily: AppFonts.productSans,
                                    fontSize: 16))),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );

  void _loginPageConsumerListener(
      BuildContext context, LoginState state) async {
    if (state is ErrorLoginState) {
      Get.snackbar('error'.tr, state.errorMesage);

      _setLoaderVisibility(false);
    } else if (state is LoadingLoginState) {
      _setLoaderVisibility(true);
    } else {
      _setLoaderVisibility(false);
    }
  }

  void _setLoaderVisibility(bool visible) =>
      setState(() => _shouldShowLoader = visible);

  void _onHidePasswordPressed() =>
      setState(() => _shouldHidePassword = !_shouldHidePassword);

  void _onRememberMeChecked(bool? checked) =>
      setState(() => _shouldRememberLogin = checked!);

  Future _onLoginPressed() async {
    var isLoggedIn = await _cubit.login(_loginTextFieldController.text,
        _passwordTexFieldController.text, _shouldRememberLogin);

    if (isLoggedIn) {
      await Get.offAll(() => const MainPage());

      _clearFields();
    }
  }

  void _onCreateAccountPressed() async {
    _clearFields();

    var navigationResult = await Get.to(const CreateAccountPage());

    if (navigationResult != null) {
      _loginTextFieldController.text = navigationResult;
    }
  }

  void _clearFields() {
    _passwordTexFieldController.text = "";
    _loginTextFieldController.text = "";
  }
}
