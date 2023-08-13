import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'comments_page.dart';

class LoadingIndicatorPage extends StatefulWidget {
  const LoadingIndicatorPage({super.key});

  @override
  _LoadingIndicatorPageState createState() => _LoadingIndicatorPageState();
}

class _LoadingIndicatorPageState extends State<LoadingIndicatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Loading indicator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_rounded),
            color: Colors.white,
            onPressed: () => {Get.to(() => CommentsPage())},
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: const Center(child: RainbowLoader()),
      ),
    );
  }
}

class RainbowLoader extends StatefulWidget {
  const RainbowLoader({super.key});

  @override
  State<RainbowLoader> createState() => _RainbowLoaderState();
}

class _RainbowLoaderState extends State<RainbowLoader> {
  double _progressBarValue = 0.0;
  bool _isLoading = false;
  late Timer _timer;
  final Random _rand = Random();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LinearProgressIndicator(
          value: _progressBarValue,
          valueColor: AlwaysStoppedAnimation(
              _progressBarValue < 1 ? Colors.blue : Colors.green),
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 10),
        Text(
          "${(_progressBarValue * 100).round()} %",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        IconButton(
            onPressed: _onLoadingButtonPress,
            icon: Icon(
              _isLoading ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            )),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _onResetButtonPress,
          style: TextButton.styleFrom(
            side: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
          child: const Text(
            "Reset loading indicator",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  void _onResetButtonPress() {
    setState(() {
      _resetLoading();
    });
  }

  void _onLoadingButtonPress() {
    setState(() {
      if (_progressBarValue >= 1) {
        _resetLoading();
      }

      _isLoading = !_isLoading;

      if (_isLoading) {
        _timer =
            Timer.periodic(const Duration(milliseconds: 100), _onTimerTick);
      }
    });
  }

  void _onTimerTick(Timer timer) {
    setState(() {
      if (_progressBarValue < 1 && _isLoading) {
        var newValue = _progressBarValue + _rand.nextInt(10) / 1000;
        _progressBarValue = newValue > 1 ? 1 : newValue;
      } else {
        timer.cancel();
        _isLoading = false;
      }
    });
  }

  void _resetLoading() {
    _progressBarValue = 0.0;
    _isLoading = false;
    _timer.cancel();
  }
}
