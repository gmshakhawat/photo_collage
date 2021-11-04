import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_collage/src/constant/skt_color.dart';
import 'package:photo_collage/src/image_preview/image_preview.dart';
import 'package:photo_collage/src/widgets/bg.dart';
import 'package:photo_collage/src/widgets/loader.dart';
import 'package:photo_collage/src/widgets/skt_button.dart';
import 'package:photo_collage/src/widgets/skt_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class _HomeScreenState extends State<HomeScreen> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: SktText(
      //     text: "Photo Collage Maker",
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Background(),
            Align(
              alignment: Alignment.topCenter,
              child: SktText(
                text: "Photo Collage Maker",
                fsize: 25,
                color: SktColors.white,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: SktButton(
                        text: "Select Photos", onPress: _onPhotoSelection)),
                SizedBox(
                  height: 20,
                ),
                if (_imageFileList != null && _imageFileList!.length > 0)
                  Expanded(
                    child: ImagePreview(
                      imageFileList: _imageFileList,
                      onChange: _singleImageChange,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onPhotoSelection() async {
    try {
      sktProgressLoader(context);

      final pickedFileList = await _picker.pickMultiImage(
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        imageQuality: 100,
      );
      setState(() {
        if (_imageFileList != null && _imageFileList!.length > 0) {
          _imageFileList!.clear();
        }
        _imageFileList = pickedFileList;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }

    Navigator.of(context).pop();
  }

  _singleImageChange(index, isNew) async {
    try {
      sktProgressLoader(context);
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        imageQuality: 100,
      );
      setState(() {
        if (isNew) {
          _imageFileList!.add(pickedFile!);
        } else {
          _imageFileList!.removeAt(index);
          _imageFileList!.insert(index, pickedFile!);
        }

        // Navigator.of(context).pop();
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }

    Navigator.of(context).pop();
  }
}
