import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/cubits/create_account_cubit.dart';
import '../../cubit/states/create_account_state.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final CreateAccountCubit cubit = CreateAccountCubit();
  final _nameTextFieldController = TextEditingController();
  final _emailTextFieldController = TextEditingController();
  final _passwordTexFieldController = TextEditingController();
  final _confirmPasswordTexFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state.isAccountCreatedSuccessfully) {
          Get.back(result: state.newUserLogin);
          Get.snackbar('message'.tr, "${'accountFor'.tr} ${state.newUserLogin} ${'createdSuccessfully'.tr}");
        } else if (state.errorText != null) {
          Get.snackbar('error'.tr, state.errorText!);
        }
      },
      bloc: cubit,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('createYourAccount'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameTextFieldController,
                decoration: InputDecoration(
                  hintText: 'username'.tr,
                  hintStyle: const TextStyle(color: Colors.black54),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
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
                controller: _emailTextFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'email'.tr,
                  hintStyle: const TextStyle(color: Colors.black54),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
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
                    onPressed: () =>
                        cubit.setShouldHidePassword(!state.shouldHidePassword),
                  ),
                  hintText: 'password'.tr,
                  hintStyle: const TextStyle(color: Colors.black54),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
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
                controller: _confirmPasswordTexFieldController,
                obscureText: state.shouldHidePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        state.shouldHidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.deepPurpleAccent),
                    onPressed: () =>
                        cubit.setShouldHidePassword(!state.shouldHidePassword),
                  ),
                  hintText: 'confirmPassword'.tr,
                  hintStyle: const TextStyle(color: Colors.black54),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10.0)),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  cubit.createAccount(
                      _nameTextFieldController.text,
                      _emailTextFieldController.text,
                      _passwordTexFieldController.text,
                      _confirmPasswordTexFieldController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text('createAnAccount'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
