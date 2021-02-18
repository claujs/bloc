import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

import 'file_source.dart';

class MegaFilePicker {
  static Future<File> askForFile(BuildContext context) async {
    final localizations = MegaleiosLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final FileSource imageSource = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.translate('where_want_to_choose_the_file'),
          style: textTheme.headline4,
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(localizations.translate('camera')),
            onPressed: () => Navigator.pop(context, FileSource.camera),
          ),
          MaterialButton(
            child: Text(localizations.translate('gallery')),
            onPressed: () => Navigator.pop(context, FileSource.image),
          ),
          MaterialButton(
            child: Text(localizations.translate('files')),
            onPressed: () => Navigator.pop(context, FileSource.custom),
          )
        ],
      ),
    );

    File file;
    if (imageSource == FileSource.camera) {
      final result = await ImagePicker().getImage(source: ImageSource.camera);
      file = result != null ? File(result.path) : null;
    }
    if (imageSource == FileSource.image) {
      final result = await ImagePicker().getImage(source: ImageSource.gallery);
      file = result != null ? File(result.path) : null;
    } else if (imageSource == FileSource.custom) {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'jpg', 'png', 'pdf'],
      );
    }

    if (file != null) {
      return file;
    }
    return null;
  }
}
