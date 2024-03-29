import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SlidableItem extends StatelessWidget {
  final Widget child;
  final List<Widget> secondaryActions;

  SlidableItem({
    @required this.child,
    @required this.secondaryActions,
  })  : assert(child != null),
        assert(secondaryActions != null && secondaryActions.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: secondaryActions,
      child: child,
    );
  }

  static Widget removeAction({Function onRemove}) {
    return GestureDetector(
      onTap: () => onRemove(),
      child: const Center(
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 20,
          child: Icon(
            FontAwesomeIcons.trash,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
