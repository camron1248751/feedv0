import 'package:flutter/material.dart';





// Top is a appBar for the feed that contains "stories" or circle avatars with
// asset images populating them currently






class Stories extends StatefulWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("images/jude.jpeg"),
                ),
                Text(
                  "Camron",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                )
              ]
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          alignment: Alignment.centerLeft,
          child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("images/Cam.jpeg"),
                ),
                Text(
                  "Camron",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                )
              ]
          ),
        ),
        const SizedBox(width: 8,),
      ],
    );
  }
}
