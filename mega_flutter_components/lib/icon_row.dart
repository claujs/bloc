import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final TextAlign align;

  const IconRow({
    @required this.icon,
    @required this.label,
    this.size = 12,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: FaIcon(
              icon,
              color: Theme.of(context).toggleableActiveColor,
              size: size,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 3,
              textAlign: align,
            ),
          )
        ],
      ),
    );
  }
}
