import 'package:flutter/material.dart';





// Not useful right now, unfinished and tbd for use case






class Profile extends StatefulWidget {
  static const id = "profile";
  final String? user;
  const Profile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: RichText(
            text: TextSpan(
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
      bottomNavigationBar: _BottomAppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/jude.jpeg"),
              fit: BoxFit.cover),
        ),
      )
    );
  }
}

class _BottomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.black,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.people),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}