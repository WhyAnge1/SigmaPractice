import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/account_settings_cubit.dart';
import 'package:flutter_practice/cubit/states/account_settings_state.dart';
import 'package:get/get.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import '../controls/custom_confirm_dialog.dart';
import 'login_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage>
    with AfterLayoutMixin<AccountSettingsPage> {
  final _cubit = AccountSettingsCubit();
  final _nameTextFieldController = TextEditingController();
  final _emailTextFieldController = TextEditingController();
  final _oldPasswordTexFieldController = TextEditingController();
  final _newPasswordTexFieldController = TextEditingController();
  final _confirmNewPasswordTexFieldController = TextEditingController();
  bool _shouldHidePassword = true;

  @override
  void afterFirstLayout(BuildContext context) {
    var currentUser = _cubit.getCurrentUserData();

    _nameTextFieldController.text = currentUser.username;
    _emailTextFieldController.text = currentUser.email;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _onLogOutPressed,
              icon: const Icon(
                Icons.logout_outlined,
                color: AppColors.textBlack,
              ))
        ],
        backgroundColor: AppColors.backgroundWhite,
        shadowColor: Colors.transparent,
        title: Text('accountSettings'.tr,
            style: const TextStyle(
                color: AppColors.textBlack,
                fontFamily: AppFonts.productSans,
                fontSize: 22,
                height: 2,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textBlack,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
          listener: _accountSettingsPageConsumerListener,
          bloc: _cubit,
          builder: _createAccountSettingsPageConsumerBuilder,
        ),
      ));

  Widget _createAccountSettingsPageConsumerBuilder(
          BuildContext context, AccountSettingsState state) =>
      Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('username'.tr,
                style: const TextStyle(
                    color: AppColors.helpTextGrey,
                    fontFamily: AppFonts.productSans,
                    fontSize: 14)),
          ),
          TextField(
            controller: _nameTextFieldController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'enterYourUsername'.tr,
              hintStyle: const TextStyle(
                  color: AppColors.disabledGrey,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('email'.tr,
                  style: const TextStyle(
                      color: AppColors.helpTextGrey,
                      fontFamily: AppFonts.productSans,
                      fontSize: 14))),
          TextField(
            controller: _emailTextFieldController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'enterYourEmail'.tr,
              hintStyle: const TextStyle(
                  color: AppColors.disabledGrey,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
            ),
          ),
          const SizedBox(height: 80),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('oldPassword'.tr,
                  style: const TextStyle(
                      color: AppColors.helpTextGrey,
                      fontFamily: AppFonts.productSans,
                      fontSize: 14))),
          TextField(
            controller: _oldPasswordTexFieldController,
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
              hintText: 'enterOldPassword'.tr,
              hintStyle: const TextStyle(
                  color: AppColors.disabledGrey,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('newPassword'.tr,
                  style: const TextStyle(
                      color: AppColors.helpTextGrey,
                      fontFamily: AppFonts.productSans,
                      fontSize: 14))),
          TextField(
            controller: _newPasswordTexFieldController,
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
              hintText: 'enterNewPassword'.tr,
              hintStyle: const TextStyle(
                  color: AppColors.disabledGrey,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('confirmPassword'.tr,
                  style: const TextStyle(
                      color: AppColors.helpTextGrey,
                      fontFamily: AppFonts.productSans,
                      fontSize: 14))),
          TextField(
            controller: _confirmNewPasswordTexFieldController,
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
              hintText: 'confirmNewPassword'.tr,
              hintStyle: const TextStyle(
                  color: AppColors.disabledGrey,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.separatorGrey),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _onSavePressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundBlack,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
            child: Text('save'.tr,
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
              Text('tiredOfOurApp'.tr,
                  style: const TextStyle(
                      color: AppColors.textBlack,
                      fontFamily: AppFonts.productSans,
                      fontSize: 16)),
              TextButton(
                  onPressed: _onDeleteAccountPressed,
                  child: Text('deleteYourAccount'.tr,
                      style: const TextStyle(
                          color: AppColors.backgroundRed,
                          decoration: TextDecoration.underline,
                          fontFamily: AppFonts.productSans,
                          fontSize: 16))),
            ],
          ),
        ],
      );

  void _accountSettingsPageConsumerListener(
      BuildContext context, AccountSettingsState state) {
    if (state.errorText != null) {
      Get.snackbar('error'.tr, state.errorText!);
    }
  }

  void _onHidePasswordPressed() =>
      setState(() => _shouldHidePassword = !_shouldHidePassword);

  Future _onSavePressed() async {
    var isDataSaved = await _cubit.saveNewUserInfo(
        _nameTextFieldController.text,
        _emailTextFieldController.text,
        _oldPasswordTexFieldController.text,
        _newPasswordTexFieldController.text,
        _confirmNewPasswordTexFieldController.text);

    if (isDataSaved) {
      Get.snackbar('info', 'newDataSavedSuccessfully'.tr);
    }
  }

  Future _onLogOutPressed() async {
    var isLoggedOut = await _cubit.logout();

    if (isLoggedOut) {
      await Get.offAll(const LoginPage());
    }
  }

  void _onBackPressed() => Get.back();

  Future _onDeleteAccountPressed() async =>
      await Get.dialog(CustomConformDialog(
        titleText: 'deleteAccount'.tr,
        bodyText: 'deleteAccountDialogText'.tr,
        confirmText: 'delete'.tr,
        cancelText: 'cancel'.tr,
        onConfirmPressed: _onConfirmDeletePressed,
        onCancelPressed: _onCancelDialogPressed,
      ));

  Future _onConfirmDeletePressed() async {
    await _cubit.deleteAccount();

    await Get.offAll(const LoginPage());
  }

  void _onCancelDialogPressed() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}