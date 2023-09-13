import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/app_colors.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../cubit/cubits/text_to_speach_cubit.dart';
import '../../cubit/states/text_to_speach_state.dart';
import '../../misc/app_fonts.dart';
import 'account_settings_page.dart';

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
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        shadowColor: Colors.transparent,
        title: Text('convertAnyTextToAudio'.tr,
            style: const TextStyle(
                color: AppColors.textBlack,
                fontFamily: AppFonts.productSans,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            onPressed: _onAccountPressed,
            icon: const Icon(
              Icons.person,
              color: AppColors.textBlack,
            )),
      ),
      body: Stack(
        children: [
          Visibility(
              visible: _shouldShowLoader,
              child: const Center(
                child: LoadingIndicator(
                    colors: [AppColors.backgroundBlack],
                    indicatorType: Indicator.ballClipRotateMultiple),
              )),
          Opacity(
            opacity: _shouldShowLoader ? 0.4 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _textFieldController,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'enterYourText'.tr,
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
                  onPressed: _onConvertPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundBlack,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  child: Text('convert'.tr,
                      style: const TextStyle(
                          color: AppColors.backgroundWhite,
                          fontFamily: AppFonts.productSans,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
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
                            color: AppColors.backgroundBlack,
                            size: 30,
                          ),
                        );
                      } else {
                        return const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.play_arrow,
                            color: AppColors.disabledGrey,
                            size: 30,
                          ),
                        );
                      }
                    }),
              ]),
            ),
          ),
        ],
      ));

  void _textToSpeachPageConsumerListener(
      BuildContext context, TextToSpeachState state) {
    if (state is ErrorTextToSpeachState) {
      Get.snackbar('error'.tr, state.errorMesage);
      _setLoaderVisibility(false);
    } else if (state is LoadingTextToSpeachState) {
      _setLoaderVisibility(true);
    } else {
      _setLoaderVisibility(false);
    }
  }

  void _setLoaderVisibility(bool visible) =>
      setState(() => _shouldShowLoader = visible);

  Future _onAccountPressed() async => await Get.to(const AccountSettingsPage());

  void _onConvertPressed() =>
      _cubit.convertTextToSpeach(_textFieldController.text);

  void _playPressed(bool isOnPause) =>
      isOnPause ? _cubit.playAudioFile() : _cubit.pauseAudioFile();
}
