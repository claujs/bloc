import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

class MegaShare {
  static void share({@required String text}) {
    Share.share(text);
  }

  static void subject({@required String text, String subject = null}) {
    Share.share(text, subject: subject);
  }

  static void shareFiles({
    @required List<String> paths,
    List<String> mimeTypes = null,
    String subject = null,
    String text = null,
    Rect sharePositionOrigin = null,
  }) {
    Share.shareFiles(paths,
        mimeTypes: mimeTypes,
        subject: subject,
        text: text,
        sharePositionOrigin: sharePositionOrigin);
  }
}
