import 'package:flutter/material.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';

class CustomConformDialog extends StatelessWidget {
  final String titleText;
  final String bodyText;
  final String cancelText;
  final String confirmText;
  final Function() onConfirmPressed;
  final Function() onCancelPressed;

  const CustomConformDialog({required this.titleText, required this.bodyText, required this.cancelText, required this.confirmText, required this.onConfirmPressed,required this.onCancelPressed, super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.backgroundWhite),
          width: 300,
          height: 210,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(children: [
              DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textBlack,
                      fontFamily: AppFonts.productSans,
                      fontSize: 22,
                      height: 2,
                      fontWeight: FontWeight.bold),
                  child: Text(titleText)),
              const SizedBox(height: 20),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textBlack,
                    fontFamily: AppFonts.productSans,
                    fontSize: 16),
                child: Text(bodyText),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onConfirmPressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: Text(confirmText,
                        style: const TextStyle(
                            color: AppColors.backgroundWhite,
                            fontFamily: AppFonts.productSans,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: onCancelPressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.backgroundBlack,
                            ))),
                    child: Text(cancelText,
                        style: const TextStyle(
                            color: AppColors.textBlack,
                            fontFamily: AppFonts.productSans,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                ],
              )
            ]),
          ),
        ),
      );
}
