import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/repository/models/comment_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../cubit/cubits/comments_cubit.dart';
import '../../misc/comments_state.dart';
import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import '../cells/comment_cell.dart';
import 'account_settings_page.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage>
    with AutomaticKeepAliveClientMixin, AfterLayoutMixin<CommentsPage> {
  final _cubit = CommentsCubit();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final _commentTextFieldController = TextEditingController();
  final PanelController _panelController = PanelController();
  double _formRating = 3.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _commentTextFieldController.dispose();

    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _cubit.loadComments();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldGlobalKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          shadowColor: Colors.transparent,
          title: Text('comments'.tr,
              style: const TextStyle(
                  color: AppColors.textBlack,
                  fontFamily: AppFonts.productSans,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
              onPressed: _onAccountPressed,
              icon: const Icon(Icons.person, color: AppColors.textBlack)),
        ),
        backgroundColor: AppColors.backgroundWhite,
        body: SlidingUpPanel(
          controller: _panelController,
          panel: _constructFloatingPanel(),
          collapsed: _constructFloatingCollapsed(),
          color: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: BlocConsumer<CommentsCubit, CommentsState>(
                listener: _commentsPageConsumerListener,
                bloc: _cubit,
                builder: _commentsPageConsumerBuilder),
          ),
        ),
      );

  Widget _commentsPageConsumerBuilder(
          BuildContext context, CommentsState state) =>
      RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.iconGrey,
          child: state.comments?.isEmpty ?? true
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Column(children: [
                      const SizedBox(height: 100),
                      const Icon(
                        Icons.speaker_notes_off,
                        color: AppColors.iconGrey,
                        size: 80,
                      ),
                      const SizedBox(height: 30),
                      Text('noCommentsYet'.tr,
                          style: const TextStyle(
                              color: AppColors.iconGrey,
                              fontFamily: AppFonts.productSans,
                              fontSize: 18)),
                      const SizedBox(height: 200)
                    ]),
                  ),
                )
              : ListView.builder(
                  itemCount: state.comments!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      CommentCell(state.comments![index], _onCommentDelete)));

  Future _onRefresh() async => await _cubit.loadComments();

  void _commentsPageConsumerListener(
      BuildContext context, CommentsState state) {
    if (state.errorText != null) {
      Get.snackbar('error'.tr, state.errorText!);
    }
  }

  Widget _constructFloatingCollapsed() {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.keyboard_arrow_up,
              color: AppColors.iconGrey, size: 30),
          const SizedBox(height: 20),
          Text(
            'pullUpToShareFeedback'.tr,
            style: const TextStyle(
                color: AppColors.textBlack,
                fontFamily: AppFonts.productSans,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _constructFloatingPanel() {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.keyboard_arrow_down,
                color: AppColors.iconGrey, size: 30),
            const SizedBox(height: 60),
            RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 50,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: AppColors.starOrange),
                onRatingUpdate: _onRatingUpdated),
            const SizedBox(height: 40),
            TextFormField(
              controller: _commentTextFieldController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'typeYourCommentHere'.tr,
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
              onPressed: _onSendButtonPressed,
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
            )
          ],
        ),
      ),
    );
  }

  Future _onAccountPressed() async => await Get.to(const AccountSettingsPage());

  Future _onCommentDelete(CommentModel modelToDelete) async =>
      await _cubit.deleteComment(modelToDelete);

  void _onRatingUpdated(double rating) => _formRating = rating;

  void _onSendButtonPressed() {
    _cubit.saveComment(_commentTextFieldController.text, _formRating);

    _formRating = 3.0;
    _commentTextFieldController.text = "";

    _panelController.close();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
