import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_collage/src/constant/skt_color.dart';
import 'package:photo_collage/src/widgets/skt_button.dart';
import 'package:photo_collage/src/widgets/skt_text.dart';
import 'package:screenshot/screenshot.dart';

class ImagePreview extends StatefulWidget {
  var imageFileList, onChange;
  ImagePreview({Key? key, this.imageFileList, this.onChange}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState(imageFileList);
}

class _ImagePreviewState extends State<ImagePreview> {
  final _imageFileList;

  _ImagePreviewState(this._imageFileList);
  ScreenshotController? _screenshotController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screenshotController = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Screenshot(
            controller: _screenshotController!,
            child: Container(
              // color: Colors.black38,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    width: 5,
                    color: Colors.green,
                  )),
              // height: MediaQuery.of(context).size.width - 10,
              child: Semantics(
                  child: GridView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      // Why network for web?
                      // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                      return Semantics(
                        label: 'photo_collage',
                        child: GestureDetector(
                            onTap: () {
                              bool isNew = false;
                              if (index == _imageFileList!.length) {
                                isNew = true;
                              }
                              widget.onChange(index, isNew);
                            },
                            child: _imageFileList!.length > index
                                ? Image.file(
                                    File(_imageFileList![index].path),
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: SktText(text: "Add Photo"),
                                  )),
                      );
                    },
                    itemCount: _imageFileList!.length > 6
                        ? 6
                        : _imageFileList!.length % 2 == 0
                            ? _imageFileList!.length
                            : _imageFileList!.length + 1,
                  ),
                  label: 'collage'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 150,
              child: SktButton(text: "Save Collage", onPress: _onSave))
        ],
      ),
    );
  }

  _onSave() async {
    var directory;

    // if (Platform.isIOS) {
    //   /// For iOS platform
    //   directory = (await getApplicationDocumentsDirectory()).path;
    // } else {
    //   /// For android platform
    //   directory = (await getTemporaryDirectory()).path;
    // }
    // String fileName = DateTime.now().toIso8601String();
    // String path = '$directory/$fileName.png';
    // print("path-$directory");

    if (_imageFileList!.length % 2 == 0 || _imageFileList!.length > 6) {
      await _screenshotController!
          .capture(delay: const Duration(milliseconds: 10))
          .then((image) async {
        if (image != null) {
          String path = "/storage/emulated/0/Download";
          if (Platform.isIOS) {
            var dir = await getApplicationDocumentsDirectory();
            path = dir.path;
          }
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }

          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File(
                  '$path/photo_College_${DateTime.now().millisecondsSinceEpoch.toString()}.png')
              .create();
          await imagePath.writeAsBytes(image);

          print("Image Saved");
          OpenFile.open("$path/image.png");

          /// Share Plugin
          // await Share.shareFiles([imagePath.path]);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: SktText(
        text: "Please add another image",
        color: SktColors.warning,
      )));
    }

    // await _screenshotController!.captureAndSave(directory);
    //  _screenshotController!.capture(path: path).then((File image) {

    //   ///Capture Done`
    //   // debugPrint("saved screenshot path1: " + image.path);

    //   // _shareScreenShot(image.path);
    // }).catchError((onError) {
    //   debugPrint(onError);
    // });
  }
}
