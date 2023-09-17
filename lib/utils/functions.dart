//Generate key pair
import 'dart:io';
import 'dart:math';

import 'package:beepo/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

List createKeywords(String userName) {
  List arrayName = [];
  String nameJoin = '';
  String userNameJoin = '';

  userName.toLowerCase().split('').forEach((letter) {
    nameJoin += letter;
    arrayName.add(nameJoin);
  });
  // username.toLowerCase().split('').forEach((letter) {
  //   userNameJoin += letter;
  //   arrayName.add(userNameJoin);
  // });
  return arrayName;
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

String formatCurrency(num num) {
  return NumberFormat.currency(symbol: '\$').format(num);
}

//format date
String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').add_jm().format(date);
}

class ImageUtil {
  Future<File?> cropProfileImage(File? file) async {
    if (file != null) {
      print(file.path);

      // try {
      //   CroppedFile? croppedFile = await ImageCropper().cropImage(
      //     sourcePath: file.path,
      //     compressQuality: 50,
      //     cropStyle: CropStyle.circle,
      //     aspectRatio: const CropAspectRatio(
      //       ratioX: 1,
      //       ratioY: 1,
      //     ),
      //   );

      return File(file.path);
      // } catch (e) {
      //   rethrow;
      // }
    }
    return null;
  }

  Future<File?> pickProfileImage({BuildContext? context}) async {
    try {
      return await showCupertinoModalPopup(
        context: context!,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                XFile? result = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  preferredCameraDevice: CameraDevice.front,
                );

                if (result != null) {
                  if ((await result.length()) > 5000000) {
                    showToast('File too large');
                    return;
                  } else {
                    Get.back(result: File(result.path));
                  }
                } else {
                  return;
                }
              },
              child: const Text('Select from Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                XFile? result =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (result != null) {
                  //File size limit - 5mb
                  if ((await result.length()) > 5000000) {
                    showToast('File too large');
                    return;
                  } else {
                    Get.back(result: File(result.path));
                  }
                } else {
                  return;
                }
              },
              child: const Text('Select from Gallery'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
