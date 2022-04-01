import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DownloadShare {

  // --- share image function ---
  shareImage(String imageurl, String? username) async {

    try {

      final uri = Uri.parse(imageurl);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/image.jpg';
      File(path).writeAsBytesSync(bytes);

      await Share.shareFiles([path], text: ' Artwork by $username. Uploaded in Animizu');

   } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error Sharing!',
        toastLength: Toast.LENGTH_LONG,
      );
   }
  }
  // --- End share image function ---

  //--- download the image ---

  Future downloadImage(String imageurl) async {

    try {

      var response = await Dio().get(imageurl,
      options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "fanartImage"
      );

        // --- showing toast message ---
        Fluttertoast.showToast(
          msg: 'Image downloaded to Gallery',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey[800],
        );
        // --- End showing toast message ---

    } catch(e) {

      Fluttertoast.showToast(
        msg: 'Download failed! error occured',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey[800],
      );


    }
  
  }

  //--- End download the image ---

}