import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../repository/models/rating_model.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final _nameTextFieldController = TextEditingController();
  final _commentTextFieldController = TextEditingController();
  final PanelController _panelController = PanelController();
  final List<RatingModel> _ratings = <RatingModel>[
    RatingModel("Sam", "It was ok", 4.0, "")
  ];
  double _formRating = 3.0;
  File _uploadedImage = File("");

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _commentTextFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Comments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.block),
            color: Colors.white,
            onPressed: () => {},
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: SlidingUpPanel(
        controller: _panelController,
        panel: _constructFloatingPanel(),
        collapsed: _constructFloatingCollapsed(),
        color: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView.builder(
            itemCount: _ratings.length,
            itemBuilder: (BuildContext context, int index) {
              return _RatingCell(
                  _ratings[index].comment,
                  _ratings[index].ownerName,
                  _ratings[index].rating,
                  _ratings[index].ownerImageFilePath);
            },
          ),
        ),
      ),
    );
  }

  Widget _constructFloatingCollapsed() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: []),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
          SizedBox(
            height: 20,
          ),
          Text(
            "Share with us your feedback",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _constructFloatingPanel() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: []),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          _constructUploadingOwnerImage(),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: TextFormField(
              controller: _nameTextFieldController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Your name",
                hintStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
              onRatingUpdate: _onRatingUpdated),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: TextFormField(
              controller: _commentTextFieldController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusColor: Colors.white,
                hintText: "Your comment",
                hintStyle: TextStyle(color: Colors.white60),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onSendButtonPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                side: const BorderSide(width: 1, color: Colors.white),
                shadowColor: Colors.grey),
            child: const Text("Send"),
          )
        ],
      ),
    );
  }

  Widget _constructUploadingOwnerImage() => _uploadedImage.path.isEmpty
      ? Stack(alignment: Alignment.center, children: [
          const Image(
            image: AssetImage('assets/images/default_user_icon.png'),
            width: 120,
            height: 120,
          ),
          IconButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.center,
              onPressed: _uploadPhoto,
              icon: const Icon(
                Icons.photo_camera,
                color: Color.fromARGB(255, 77, 77, 77),
                size: 40,
              )),
        ])
      : SizedBox(
        width: 120,
        height: 120,
        child: CircleAvatar(
                backgroundColor: Colors.transparent,
                  backgroundImage: Image.file(_uploadedImage).image),
      );

  Future _uploadPhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _uploadedImage = File(image.path);
      });
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occured while uploading photo")));
    }
  }

  void _onRatingUpdated(double rating) => _formRating = rating;

  void _onSendButtonPressed() {
    var newRating = RatingModel(
        _nameTextFieldController.text.isEmpty
            ? "Anonym"
            : _nameTextFieldController.text,
        _commentTextFieldController.text,
        _formRating,
        _uploadedImage.path);

    setState(() {
      _ratings.add(newRating);
    });
    _uploadedImage = File("");
    _formRating = 3.0;
    _commentTextFieldController.text = "";
    _nameTextFieldController.text = "";

    _panelController.close();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class _RatingCell extends StatelessWidget {
  final String _comment;
  final String _ownerName;
  final double _rating;
  final String _ownerImage;

  const _RatingCell(
      this._comment, this._ownerName, this._rating, this._ownerImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
                backgroundImage: _ownerImage.isEmpty
                    ? AssetImage('assets/images/default_user_icon.png')
                    : Image.file(File(_ownerImage)).image),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _ownerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      initialRating: _rating,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.yellow,
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
                  _comment.isEmpty ? "No comment" : _comment,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
