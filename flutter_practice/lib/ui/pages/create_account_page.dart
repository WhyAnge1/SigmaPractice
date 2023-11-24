import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/cubits/create_account_cubit.dart';
import '../../cubit/states/create_account_state.dart';
import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _cubit = CreateAccountCubit();
  final _nameTextFieldController = TextEditingController();
  final _emailTextFieldController = TextEditingController();
  final _passwordTexFieldController = TextEditingController();
  final _confirmPasswordTexFieldController = TextEditingController();
  bool _shouldHidePassword = true;

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _emailTextFieldController.dispose();
    _passwordTexFieldController.dispose();
    _confirmPasswordTexFieldController.dispose();
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<CreateAccountCubit, CreateAccountState>(
        listener: _createAccountPageConsumerListener,
        bloc: _cubit,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.backgroundPrimary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 35, left: 20, right: 20, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Text(
                      'createYourAccountTitle'.tr,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: AppFonts.productSans,
                          fontSize: 24,
                          height: 2,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    flex: 11,
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameTextFieldController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'enterYourUsername'.tr,
                            hintStyle: const TextStyle(
                                color: AppColors.textHelp,
                                fontFamily: AppFonts.productSans,
                                fontSize: 16),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _emailTextFieldController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'emailAdress'.tr,
                            hintStyle: const TextStyle(
                                color: AppColors.textHelp,
                                fontFamily: AppFonts.productSans,
                                fontSize: 16),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
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
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _confirmPasswordTexFieldController,
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
                            hintText: 'confirmPassword'.tr,
                            hintStyle: const TextStyle(
                                color: AppColors.textHelp,
                                fontFamily: AppFonts.productSans,
                                fontSize: 16),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _onCreateAccountPressed,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          child: Text(
                            'signUpCaps'.tr,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: AppFonts.productSans,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('alreadyHaveAnAccount'.tr,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: AppFonts.productSans,
                              fontSize: 16)),
                      TextButton(
                        onPressed: _onLogInPressed,
                        child: Text(
                          'logIn'.tr,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              decoration: TextDecoration.underline,
                              fontFamily: AppFonts.productSans,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _createAccountPageConsumerListener(
      BuildContext context, CreateAccountState state) {
    if (state is ErrorCreateAccountState) {
      Get.snackbar('error'.tr, state.errorMesage);
    } else if (state is SuccessfulCreateAccountState) {
      Get.back(result: _emailTextFieldController.text);
      Get.snackbar('info'.tr,
          "${'accountFor'.tr} ${_emailTextFieldController.text} ${'createdSuccessfully'.tr} ${'verificationLinkIsSendToYourEmail'.tr}");
    }
  }

  void _onHidePasswordPressed() =>
      setState(() => _shouldHidePassword = !_shouldHidePassword);

  Future _onCreateAccountPressed() async {
    await _cubit.createAccount(
        _nameTextFieldController.text,
        _emailTextFieldController.text,
        _passwordTexFieldController.text,
        _confirmPasswordTexFieldController.text);
  }

  void _onLogInPressed() => Get.back();
}
