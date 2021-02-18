import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MenuListItem extends StatelessWidget {
  final String title;
  final String leadingImage;
  final TextStyle style;
  final bool enabled;
  final bool hasTrailing;
  final bool hasDivider;
  final Function onTap;

  MenuListItem(
    this.title, {
    this.leadingImage,
    @required this.style,
    this.enabled = true,
    this.hasTrailing = false,
    this.hasDivider = false,
    this.onTap,
  })  : assert(title != null && title.isNotEmpty),
        assert(style != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _leadingWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      title,
                      style: style ?? Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                Visibility(
                  visible: hasTrailing,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: style.color,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
          Visibility(
            visible: hasDivider,
            child: Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).backgroundColor,
            ),
          )
        ],
      ),
    );
  }

  _leadingWidget() {
    if (leadingImage == null || leadingImage.trim().isEmpty) {
      return Container();
    }

    return SizedBox(
      width: 20,
      child: Center(
        child: Image.asset(
          leadingImage,
          height: 16,
          color: style.color,
        ),
      ),
    );
  }
}
