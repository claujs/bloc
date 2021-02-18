import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mega_flutter_components/animated_column.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'mega_base_bloc.dart';

abstract class MegaBaseScreen extends StatefulWidget {
  const MegaBaseScreen({Key key}) : super(key: key);
  String get screenName => this.runtimeType.toString();
  String get screenNameLocalized => null;

  bool get hasBackAction => true;
  bool get hasTransparentToolbar => false;
  bool get hasToolbar => true;
  bool get safeArea => true;
  static const String screenTitleTag = 'screen_title';
}

abstract class MegaBaseScreenState<Page extends MegaBaseScreen>
    extends State<Page> {}

mixin MegaBaseScreenMixin<Page extends MegaBaseScreen>
    on MegaBaseScreenState<Page> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Widget> actions = [];
  bool _hasNetworkAccess = true;

  MegaBaseBloc appBloc = Modular.get<MegaBaseBloc>();

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _hasNetworkAccess = result != ConnectivityResult.none;
      });
    });

    appBloc.error.listen((value) {
      if (value != null && value.trim().isNotEmpty && context != null) {
        if (ModalRoute.of(context).isCurrent) {
          final snackBar = SnackBar(
            content: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    });

    appBloc.message.listen((value) {
      if (value != null && value.trim().isNotEmpty && context != null) {
        if (ModalRoute.of(context).isCurrent) {
          final snackBar = SnackBar(
              content: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.black);
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    });

    verifyConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: appBloc.isLoading,
      initialData: false,
      builder: (context, isLoading) {
        if (!_hasNetworkAccess) {
          return Scaffold(
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: AnimatedColumn(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          MegaleiosLocalizations.of(context)
                              .translate('no_network_access'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        if (isLoading.data) {
          FocusScope.of(context).requestFocus(FocusNode());
        }

        return ModalProgressHUD(
          opacity: 0.8,
          progressIndicator: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          child: buildScreen(context),
          inAsyncCall: isLoading.data,
        );
      },
    );
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: widget.hasToolbar ? buildAppBar() : null,
      body: widget.safeArea ? SafeArea(child: body(context)) : body(context),
    );
  }

  Widget body(BuildContext context) => Container();

  Widget buildAppBar({String title}) {
    String screenTitle = title ?? widget.screenName;

    if (widget.screenNameLocalized != null && title == null)
      screenTitle = MegaleiosLocalizations.of(context)
          .translate(widget.screenNameLocalized);

    return PreferredSize(
      preferredSize: AppBar().preferredSize,
      child: Hero(
        tag: 'megaleios-app-bar',
        transitionOnUserGestures: true,
        child: AppBar(
            backgroundColor: widget.hasTransparentToolbar
                ? Colors.transparent
                : Theme.of(context).appBarTheme.color,
            elevation: 0,
            leading: widget.hasBackAction
                ? Center(
                    child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: Theme.of(context).appBarTheme.iconTheme.size,
                        ),
                        onPressed: () => Navigator.of(context).pop()))
                : Container(),
            centerTitle: true,
            title: Text(
              screenTitle,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).appBarTheme.iconTheme.color,
                  ),
              maxLines: 1,
            ),
            actions: actions),
      ),
    );
  }

  Future<void> verifyConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasNetworkAccess = connectivityResult != ConnectivityResult.none;
    });
  }

  openDrawer() {
    if (!scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openDrawer();
    }
  }
}
