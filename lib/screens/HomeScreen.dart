import 'package:flutter/material.dart';
import 'package:feedtest/classes/LifeNote.dart';
import 'package:feedtest/classes/Bottom.dart';




// HomeScreen is a feed that could be able to, for v0, pull selected images
// from the PreHome screen and populate a feed with highlights and their audios

// Currently, it is an example file for a feed with an asset image, but in the future could be
// translated to Image.memory snapshots from the PreHome screen






class HomeScreen extends StatefulWidget {
  static const id = "homescreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller; // keeping track of activity in a way that can be used for animation
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;
  bool isPlaying = false;
  bool isLongPressed = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: RichText(
            text: const TextSpan(
                children: [
                  TextSpan(
                      text: "LifeNotes",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20
                      )
                    //recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, HomeScreen.id)
                  ),
                ]
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) => {}, //initRecorder(),
        onTapUp: (_) => {}, //record.stop(),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          // tooltip: 'Create',
          child: const Icon(Icons.mic),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Bottom(),
      body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Stories(),
                const Divider(
                  height: 5,
                  color: Colors.white,
                ),
                const SizedBox(height: 10,),
                // 
                LifeNote()
              ],
            ),
          ),
    );
  }
}



