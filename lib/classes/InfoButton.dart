import 'package:flutter/material.dart';





// Not useful right now, unfinished






class InfoButton extends StatelessWidget {
  final Color color;
  final String title;
  final void Function()? onPress;
  const InfoButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPress,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}