import 'package:flutter/material.dart';


class PlayPauseWidget extends StatelessWidget {
  final IconData iconData;
  final Function()? onPressed;
  final double iconSize;
  final Color color;
  const PlayPauseWidget({
    Key? key,
    required this.iconData,
    required this.onPressed,
    this.iconSize = 84,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: key,
      onPressed: onPressed,
      iconSize:iconSize,
      icon: Icon(iconData),
      color: Colors.white,
    );
  }
}
