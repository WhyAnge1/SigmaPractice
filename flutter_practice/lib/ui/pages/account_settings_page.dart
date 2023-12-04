import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/account_settings_cubit.dart';
import 'package:flutter_practice/cubit/states/account_settings_state.dart';
import 'package:flutter_practice/misc/app_images.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import '../controls/custom_confirm_dialog.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage>
    with AfterLayoutMixin<AccountSettingsPage>, AutomaticKeepAliveClientMixin {
  final _cubit = AccountSettingsCubit();
  final _nameTextFieldController = TextEditingController();
  final _emailTextFieldController = TextEditingController();
  final _oldPasswordTexFieldController = TextEditingController();
  final _newPasswordTexFieldController = TextEditingController();
  final _confirmNewPasswordTexFieldController = TextEditingController();
  bool _shouldHidePassword = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _cubit.loadCurrentUserData();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: BlocListener<AccountSettingsCubit, AccountSettingsState>(
          listener: _accountSettingsPageConsumerListener,
          bloc: _cubit,
          child: Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            appBar: _buildAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 40, bottom: 5),
                child: BlocBuilder<AccountSettingsCubit, AccountSettingsState>(
                  bloc: _cubit,
                  builder: (context, state) => Stack(
                    children: [
                      Visibility(
                        visible: state is LoadingAvatarAccountSettingsState &&
                            state.isLoading,
                        child: const LoadingIndicator(
                          colors: [AppColors.indicatorPrimary],
                          indicatorType: Indicator.ballClipRotateMultiple,
                        ),
                      ),
                      Opacity(
                        opacity: state is LoadingAvatarAccountSettingsState &&
                                state.isLoading
                            ? 0.4
                            : 1,
                        child: _buildEditUserDataWidgets(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _accountSettingsPageConsumerListener(
      BuildContext context, AccountSettingsState state) {
    if (state is ErrorAccountSettingsState) {
      Get.snackbar('error'.tr, state.errorMesage);
    } else if (state is ShowInfoAccountSettingsState) {
      Get.snackbar('info', state.infoMessage);
    } else if (state is UserDataAccountSettingsState) {
      _nameTextFieldController.text = state.username;
      _emailTextFieldController.text = state.email;
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: _onLogOutPressed,
          icon: const Icon(
            Icons.logout_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
      backgroundColor: AppColors.backgroundSecondary,
      title: Text(
        'accountSettings'.tr,
        style: const TextStyle(
            color: AppColors.textPrimary,
            fontFamily: AppFonts.productSans,
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: _openDrawer,
        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildEditUserDataWidgets() {
    return Column(
      children: [
        _buildUserPhoto(),
        const SizedBox(
          height: 40,
        ),
        _buildUsernameWidgets(),
        const SizedBox(
          height: 40,
        ),
        _buildEmailWidgets(),
        const SizedBox(
          height: 80,
        ),
        _buildPasswordWidgets(),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: _onSavePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 35,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                18.0,
              ),
            ),
          ),
          child: Text(
            'save'.tr,
            style: const TextStyle(
              color: AppColors.backgroundPrimary,
              fontFamily: AppFonts.productSans,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'tiredOfOurApp'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: AppFonts.productSans,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: _onDeleteAccountPressed,
              child: Text(
                'deleteYourAccount'.tr,
                style: const TextStyle(
                  color: AppColors.textRed,
                  decoration: TextDecoration.underline,
                  fontFamily: AppFonts.productSans,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsernameWidgets() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'username'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 14,
            ),
          ),
        ),
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
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailWidgets() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'email'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 14,
            ),
          ),
        ),
        TextField(
          controller: _emailTextFieldController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'enterYourEmail'.tr,
            hintStyle: const TextStyle(
              color: AppColors.textHelp,
              fontFamily: AppFonts.productSans,
              fontSize: 16,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordWidgets() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'oldPassword'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 14,
            ),
          ),
        ),
        TextField(
          controller: _oldPasswordTexFieldController,
          obscureText: _shouldHidePassword,
          keyboardType: _shouldHidePassword
              ? TextInputType.text
              : TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _shouldHidePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: _onHidePasswordPressed,
            ),
            hintText: 'enterOldPassword'.tr,
            hintStyle: const TextStyle(
              color: AppColors.textHelp,
              fontFamily: AppFonts.productSans,
              fontSize: 16,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'newPassword'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 14,
            ),
          ),
        ),
        TextField(
          controller: _newPasswordTexFieldController,
          obscureText: _shouldHidePassword,
          keyboardType: _shouldHidePassword
              ? TextInputType.text
              : TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _shouldHidePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: _onHidePasswordPressed,
            ),
            hintText: 'enterNewPassword'.tr,
            hintStyle: const TextStyle(
              color: AppColors.textHelp,
              fontFamily: AppFonts.productSans,
              fontSize: 16,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'confirmPassword'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 14,
            ),
          ),
        ),
        TextField(
          controller: _confirmNewPasswordTexFieldController,
          obscureText: _shouldHidePassword,
          keyboardType: _shouldHidePassword
              ? TextInputType.text
              : TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _shouldHidePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: _onHidePasswordPressed,
            ),
            hintText: 'confirmNewPassword'.tr,
            hintStyle: const TextStyle(
              color: AppColors.textHelp,
              fontFamily: AppFonts.productSans,
              fontSize: 16,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserPhoto() {
    return BlocBuilder<AccountSettingsCubit, AccountSettingsState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          current is UserDataAccountSettingsState ||
          current is InitialAccountSettingsState,
      builder: (context, state) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              5.0,
            ),
            child:
                state is UserDataAccountSettingsState && state.imageUrl != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.backgroundPrimary,
                        foregroundImage: NetworkImage(
                          state.imageUrl!,
                        ),
                        backgroundImage: const AssetImage(
                          AppImages.defaultUserIcon,
                        ),
                      )
                    : _buildEmptyUserImage(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _editImagePressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.backgroundPrimary,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                  color: AppColors.backgroundSecondary,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUserImage() {
    return const CircleAvatar(
      radius: 60,
      backgroundColor: AppColors.backgroundPrimary,
      backgroundImage: AssetImage(
        AppImages.defaultUserIcon,
      ),
    );
  }

  Future _editImagePressed() async => await _cubit.getImageFromGallery();

  void _onHidePasswordPressed() =>
      setState(() => _shouldHidePassword = !_shouldHidePassword);

  Future _onSavePressed() async {
    await _cubit.saveNewUserInfo(
        _nameTextFieldController.text,
        _emailTextFieldController.text,
        _oldPasswordTexFieldController.text,
        _newPasswordTexFieldController.text,
        _confirmNewPasswordTexFieldController.text);
  }

  Future _onLogOutPressed() async {
    await _cubit.logout();
  }

  void _openDrawer() => _cubit.sendOpenDrawerEvent();

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
    await _cubit.deleteAccount(_oldPasswordTexFieldController.text);
  }

  void _onCancelDialogPressed() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
