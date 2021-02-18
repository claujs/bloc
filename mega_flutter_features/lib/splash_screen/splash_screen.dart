import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_screen.dart';
import 'package:mega_flutter_network/mega_dio.dart';

class SplashScreen extends MegaBaseScreen {
  static const routeName = '/';

  @override
  bool get hasToolbar => false;

  final Color backgroundColor;
  final String imagePath;
  final double heightRatio;
  final double widthRatio;
  final int dismissTime;
  final String route;
  final Function(BuildContext) onRoute;

  const SplashScreen({
    @required this.imagePath,
    this.route,
    this.onRoute,
    this.backgroundColor,
    this.heightRatio = 0.3,
    this.widthRatio = 0.8,
    this.dismissTime = 1,
  })  : assert(imagePath != null),
        assert(route != null && onRoute == null ||
            onRoute != null && route == null),
        assert(heightRatio > 0 && heightRatio <= 1),
        assert(widthRatio > 0 && widthRatio <= 1);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends MegaBaseScreenState<SplashScreen>
    with MegaBaseScreenMixin {
  @override
  void initState() {
    super.initState();

    try {
      Modular.get<MegaDio>();
    } on Exception {
      print('FAILED TO LOAD DIO --- SPLASH SCREEN');
    }

    Timer(
      Duration(seconds: widget.dismissTime),
      () {
        if (widget.route != null) {
          Navigator.of(context).pushReplacementNamed(widget.route);
        } else {
          widget.onRoute?.call(context);
        }
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      color: this.widget.backgroundColor ?? Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              this.widget.imagePath,
              height:
                  MediaQuery.of(context).size.height * this.widget.heightRatio,
              width: MediaQuery.of(context).size.width * this.widget.widthRatio,
              fit: BoxFit.fitHeight,
            ),
            const Spacer(),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
