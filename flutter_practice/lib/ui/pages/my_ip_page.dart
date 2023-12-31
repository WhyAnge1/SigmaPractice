import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/my_ip_cubit.dart';
import 'package:flutter_practice/cubit/states/my_ip_state.dart';
import 'package:flutter_practice/misc/app_colors.dart';
import 'package:flutter_practice/misc/app_fonts.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyIpPage extends StatefulWidget {
  const MyIpPage({super.key});

  @override
  State createState() => _MyIpPageState();
}

class _MyIpPageState extends State<MyIpPage>
    with AutomaticKeepAliveClientMixin {
  final _cubit = MyIpCubit();
  bool _shouldShowLoader = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(Object context) => SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.backgroundPrimary,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            title: Text(
              'myIp'.tr,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocConsumer<MyIpCubit, MyIpState>(
                          bloc: _cubit,
                          builder: (context, state) => _buildIpText(state),
                          listener: _myIpPageConsumerListener,
                          buildWhen: (previous, current) =>
                              current is InitialMyIpState ||
                              current is DataMyIpState,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _onGetMyIpPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Text(
                            'getMyIp'.tr,
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
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildIpText(MyIpState state) =>
      Text(state is DataMyIpState ? state.ip : 'noDataFoundYet'.tr,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontWeight: FontWeight.bold,
              fontSize: 18));

  void _myIpPageConsumerListener(BuildContext context, MyIpState state) {
    _setLoaderVisibility(false);

    if (state is ErrorMyIpState) {
      Get.snackbar('error'.tr, state.errorMesage);
    } else if (state is LoadingMyIpState) {
      _setLoaderVisibility(true);
    }
  }

  void _setLoaderVisibility(bool visible) =>
      setState(() => _shouldShowLoader = visible);

  Future _onGetMyIpPressed() async => await _cubit.getMyIp();

  void _openDrawer() => _cubit.sendOpenDrawerEvent();
}
