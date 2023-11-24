import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/login_cubit.dart';
import 'package:flutter_practice/cubit/states/login_state.dart';
import 'package:flutter_practice/ui/pages/home_page.dart';
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
  bool _shouldShowLoader = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _cubit.tryAutoLogin();
  }

  @override
  void dispose() {
    _loginTextFieldController.dispose();
    _passwordTexFieldController.dispose();
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<LoginCubit, LoginState>(
        listener: _loginPageConsumerListener,
        bloc: _cubit,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.backgroundPrimary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 35, left: 20, right: 20, bottom: 5),
              child: Stack(
                children: [
                  Visibility(
                      visible: _shouldShowLoader,
                      child: const Center(
                        child: LoadingIndicator(
                            colors: [AppColors.backgroundSecondary],
                            indicatorType: Indicator.ballClipRotateMultiple),
                      )),
                  Opacity(
                    opacity: _shouldShowLoader ? 0.4 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'logIntoYourAccount'.tr,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: AppFonts.productSans,
                                fontSize: 24,
                                height: 2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 13,
                          child: Column(
                            children: [
                              TextField(
                                controller: _loginTextFieldController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'emailAdress'.tr,
                                  hintStyle: const TextStyle(
                                      color: AppColors.textHelp,
                                      fontFamily: AppFonts.productSans,
                                      fontSize: 16),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textPrimary),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textPrimary),
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
                                        color: AppColors.textPrimary),
                                    onPressed: _onHidePasswordPressed,
                                  ),
                                  hintText: 'password'.tr,
                                  hintStyle: const TextStyle(
                                      color: AppColors.textHelp,
                                      fontFamily: AppFonts.productSans,
                                      fontSize: 16),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textPrimary),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.textPrimary),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _onLoginPressed,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                child: Text(
                                  'logInCaps'.tr,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontFamily: AppFonts.productSans,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('dontHaveAnAccount'.tr,
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: AppFonts.productSans,
                                          fontSize: 16)),
                                  TextButton(
                                    onPressed: _onCreateAccountPressed,
                                    child: Text(
                                      'signUp'.tr,
                                      style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          decoration: TextDecoration.underline,
                                          fontFamily: AppFonts.productSans,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _loginPageConsumerListener(
      BuildContext context, LoginState state) async {
    _setLoaderVisibility(false);

    if (state is ErrorLoginState) {
      Get.snackbar('error'.tr, state.errorMesage);
    } else if (state is LoadingLoginState) {
      _setLoaderVisibility(true);
    } else if (state is SuccessfulLoginState) {
      await Get.offAll(() => const HomePage());

      _clearFields();
    }
  }

  void _setLoaderVisibility(bool visible) =>
      setState(() => _shouldShowLoader = visible);

  void _onHidePasswordPressed() =>
      setState(() => _shouldHidePassword = !_shouldHidePassword);

  Future _onLoginPressed() async {
    await _cubit.login(
        _loginTextFieldController.text, _passwordTexFieldController.text);
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
