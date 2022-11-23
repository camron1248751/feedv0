import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:feedtest/screens/Profile.dart';






// LifeNote is the widget for each highlight in the HomeScreen feed,
// Currently a picture with a description and a placeholder UI for an
// audio file that can be played







class LifeNote extends StatefulWidget {
  const LifeNote({Key? key}) : super(key: key);

  @override
  State<LifeNote> createState() => _LifeNoteState();
}

class _LifeNoteState extends State<LifeNote> {
  bool isPlaying = false;
  void changePlay() {
    setState(() {
      isPlaying = isPlaying ? false : true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const CircleAvatar(
                  backgroundImage: AssetImage("images/jude.jpeg"),
                ),
              ),
              const SizedBox(width: 5,),
              RichText(
                text: TextSpan(
                    text: "Jude",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, Profile.id)
                ),
              ),
            ]
        ),
        const SizedBox(height: 8,),
        ClipRRect(
          child: Container(
            child: Align(
              alignment: Alignment.center,
              heightFactor: .6,
              child: Container(
                child: const Image(
                  image: AssetImage('images/jude.jpeg'),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                )
            )
          ],
        ),
        Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: RichText(
                  text: TextSpan(
                      text: "",
                      children: [
                        TextSpan(
                            text: "Jude",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, Profile.id)
                        ),
                        const TextSpan(
                          text: " Jude's First day of school",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w200
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ]
        ),
        Row(
            children: [
              Text(
                " Audio: ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),
              ),
              Container(
                width: 200,
                height: 40,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "(Audio file from path)",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black38,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    )
                ),
              ),
              isPlaying ? Transform.scale(
                scale: 2.0,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.pause_circle, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      changePlay();
                    });
                  },
                ),
              ) : Transform.scale(
                scale: 2.0,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                  onPressed: () {
                    changePlay();
                  },
                ),
              )
            ]
        ),
      ],
    );
  }
}
