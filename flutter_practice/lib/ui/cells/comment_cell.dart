import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import '../../misc/app_images.dart';
import '../../repository/models/comment_model.dart';

class CommentCell extends StatelessWidget {
  final CommentModel _model;
  final Function(CommentModel) _onDelete;

  const CommentCell(this._model, this._onDelete, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: AppColors.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: _model.isBelongToCurrentUser
          ? Dismissible(
              key: ValueKey(_model),
              background: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundRed,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(10),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete_forever,
                      color: AppColors.backgroundPrimary),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: ((direction) => _onDelete(_model)),
              child: _constructCellLayout(),
            )
          : _constructCellLayout(),
    );
  }

  Widget _constructCellLayout() => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: AppColors.backgroundPrimary,
                foregroundImage: _model.ownerPhotoUrl != null
                    ? Image.network(_model.ownerPhotoUrl!).image
                    : const AssetImage(
                        AppImages.defaultUserIcon,
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _model.ownerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: AppFonts.productSans),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RatingBar.builder(
                        initialRating: _model.rating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppColors.starOrange,
                        ),
                        itemSize: 18,
                        onRatingUpdate: (rating) => {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    _model.comment,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontFamily: AppFonts.productSans),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
