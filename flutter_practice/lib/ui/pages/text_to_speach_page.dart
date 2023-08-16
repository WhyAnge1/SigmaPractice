import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/ui/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../cubit/cubits/text_to_speach_cubit.dart';
import '../../cubit/states/text_to_speach_state.dart';

class TextToSpeachPage extends StatefulWidget {
  const TextToSpeachPage({super.key});

  @override
  State createState() => _TextToSpeachPageState();
}

class _TextToSpeachPageState extends State<TextToSpeachPage> {
  final TextToSpeachCubit cubit = TextToSpeachCubit();
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    cubit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('convertTextToSpeach'.tr),
        leading: IconButton(
            onPressed: _onLogoutPressed,
            icon: const Icon(Icons.logout_outlined)),
      ),
      body: BlocConsumer<TextToSpeachCubit, TextToSpeachState>(
        listener: _textToSpeachPageConsumerListener,
        bloc: cubit,
        builder: _textToSpeachPageConsumerBuilder,
      ));

  Widget _textToSpeachPageConsumerBuilder(
          BuildContext context, TextToSpeachState state) =>
      Stack(
        children: [
          Visibility(
              visible: state.isLoading,
              child: const Center(
                child: LoadingIndicator(
                    colors: [Colors.deepPurple],
                    indicatorType: Indicator.ballClipRotateMultiple),
              )),
          Opacity(
            opacity: state.isLoading ? 0.4 : 1,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _textFieldController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'enterYourText'.tr,
                    hintStyle: const TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onConvertPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text('convert'.tr),
                ),
                IconButton(
                  onPressed:
                      state.isAudioExist ? () => _playPressed(state) : null,
                  icon: Icon(
                    state.isOnPause ? Icons.play_arrow : Icons.pause,
                    color: state.isAudioExist ? Colors.deepPurple : Colors.grey,
                    size: 30,
                  ),
                ),
              ]),
            ),
          ),
        ],
      );

  void _textToSpeachPageConsumerListener(
      BuildContext context, TextToSpeachState state) {
    if (state.shouldLogout) {
      Get.offAll(const LoginPage());
    } else if (state.errorText != null) {
      Get.snackbar('error'.tr, state.errorText!);
    }
  }

  void _onLogoutPressed() async => await cubit.logout();

  void _onConvertPressed() =>
      cubit.convertTextToSpeach(_textFieldController.text);

  void _playPressed(TextToSpeachState state) =>
      state.isOnPause ? cubit.playAudioFile() : cubit.pauseAudioFile();
}
