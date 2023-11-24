import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/app_colors.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../cubit/cubits/text_to_speach_cubit.dart';
import '../../cubit/states/text_to_speach_state.dart';
import '../../misc/app_fonts.dart';

class TextToSpeachPage extends StatefulWidget {
  const TextToSpeachPage({super.key});

  @override
  State createState() => _TextToSpeachPageState();
}

class _TextToSpeachPageState extends State<TextToSpeachPage>
    with AutomaticKeepAliveClientMixin {
  final _cubit = TextToSpeachCubit();
  final _textFieldController = TextEditingController();
  bool _shouldShowLoader = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'convertAnyTextToAudio'.tr,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: _openDrawer,
          icon: const Icon(
            Icons.menu,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: _shouldShowLoader,
            child: const Center(
              child: LoadingIndicator(
                  colors: [AppColors.indicatorPrimary],
                  indicatorType: Indicator.ballClipRotateMultiple),
            ),
          ),
          Opacity(
            opacity: _shouldShowLoader ? 0.4 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textFieldController,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'enterYourText'.tr,
                      hintStyle: const TextStyle(
                          color: AppColors.textHelp,
                          fontFamily: AppFonts.productSans,
                          fontSize: 16),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _onConvertPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      'convert'.tr,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: AppFonts.productSans,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                  BlocConsumer<TextToSpeachCubit, TextToSpeachState>(
                    listener: _textToSpeachPageConsumerListener,
                    bloc: _cubit,
                    buildWhen: (previous, current) => current.shouldBuild,
                    builder: (context, state) {
                      if (state is AudioTextToSpeachState) {
                        return IconButton(
                          onPressed: () => _playPressed(state.isOnPause),
                          icon: Icon(
                            state.isOnPause ? Icons.play_arrow : Icons.pause,
                            color: AppColors.textPrimary,
                            size: 30,
                          ),
                        );
                      } else {
                        return const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.play_arrow,
                            color: AppColors.disabled,
                            size: 30,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _textToSpeachPageConsumerListener(
      BuildContext context, TextToSpeachState state) {
    _setLoaderVisibility(false);

    if (state is ErrorTextToSpeachState) {
      Get.snackbar('error'.tr, state.errorMesage);
    } else if (state is LoadingTextToSpeachState) {
      _setLoaderVisibility(true);
    }
  }

  void _setLoaderVisibility(bool visible) =>
      setState(() => _shouldShowLoader = visible);

  void _openDrawer() => _cubit.sendOpenDrawerEvent();

  void _onConvertPressed() =>
      _cubit.convertTextToSpeach(_textFieldController.text);

  void _playPressed(bool isOnPause) =>
      isOnPause ? _cubit.playAudioFile() : _cubit.pauseAudioFile();
}
