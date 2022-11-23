import 'dart:async';
import 'dart:io';
import 'package:universal_io/io.dart';
import 'dart:ui';
import 'package:feedtest/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_menu/star_menu.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:path_provider/path_provider.dart';




// PreHome is the initial screen for choosing photos from a feed
// Currently doesn't have functionality to choose specific photos
// or relate audio files to photos, but this can be done with an index
// in the asset loop






class PreHome extends StatefulWidget {
  static const id = "prehome";
  const PreHome({Key? key}) : super(key: key);

  @override
  State<PreHome> createState() => _PreHomeState();
}

class _PreHomeState extends State<PreHome> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;
  late Timer _timer;
  bool isLongPressed = false;
  late FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final _formKey = GlobalKey<FormState>();
  StarMenuController starMenu = StarMenuController();
  late String fileName = "test.aac";
  final String dir = "/feedtest/audio/";
  bool isRecord = false;
  bool isRecording = false;



  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "no";
    }
    await recorder.openRecorder();
    isRecord = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }
  // Recording setup and start, no relation to photos currently


  Future record() async {
    if (!isRecord) return;
    await recorder.startRecorder(toFile: 'audio');
    isRecording = true;
  }
  @override
  Future dispose() async {
    recorder.stopRecorder();
  }

  Future<File> stop() async {
    if (!isRecord) return File("");
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print(audioFile);
    isRecording = false;
    return audioFile;
  }


  // file access functions

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt'); // going to be audio file
  }


  Future<String> readcontent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString(); // audio
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }


  void _createFile() async {
    File(dir + "recording")
        .create(recursive: true)
        .then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print(file.path);
    });
  }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(dir).exists();
    if (!isDirectoryCreated) {
      Directory(dir).create()
      // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  void _writeFileToStorage() async {
    _createDirectory();
    _createFile();
  }


  // Timer for long press detection
  void timerStart() {
    _timer = Timer(const Duration(milliseconds: 500), () {
      print('LongPress Event');
      isLongPressed = true;
      record();
      // initRecorder();
      //Navigator.pushNamed(context, HomeScreen.id);
    });
  }

  // popup menu, currently not in use, deciding on how to deal with photo press
  getAlert() {
    Widget build(BuildContext context) {
      return AlertDialog(
        content: Stack(
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 487/451,
                    child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: AssetImage("images/jude.jpeg")
                            )
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'What\'s your name?',
                        labelText: 'Name',
                      ),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'What\'s your password?',
                        labelText: 'Password',
                      ),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // for detecting which photos to render
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        newMedia();
      }
    }
  }

  newMedia() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    lastPage = currentPage;
    if (ps.isAuth) {
      // success
//load the album list
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media =
      await albums[0].getAssetListPaged(page: currentPage, size: 60);
      print(media);
      List<Widget> temp = [];
      for (var img in media) {
        temp.add(
          FutureBuilder(
            future: img.thumbnailData,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: FocusedMenuHolder(
                        menuItems: [],
                        onPressed: () {},
                        blurSize: 5.0,
                          child: StarMenu(
                            controller: starMenu,
                            lazyItems: () async {
                              return [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                    child: Icon(Icons.info, color: Colors.black,)
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      if (isRecording) {
                                        await stop();
                                      } else {
                                        final finalFile = await record();
                                        Uint8List bytes = await finalFile.readAsBytes();
                                        final dest = await _localFile;
                                        dest.writeAsBytes(bytes);
                                      }
                                      setState(() {
                                      });
                                    },
                                    child: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.black,)
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {},
                                    child: Icon(Icons.movie, color: Colors.black,)
                                ),
                              ];
                            },
                            params: StarMenuParameters(
                              shape: MenuShape.circle,
                              useLongPress: true,
                              circleShapeParams: CircleShapeParams(startAngle: media.indexOf(img).toDouble() % 3 * 45, endAngle: media.indexOf(img).toDouble() % 3 * 45 + 90)
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('tap');
                              //   showMenu(
                              //     context: context,
                              //     position: RelativeRect.fromDirectional(textDirection: TextDirection.ltr, start: 20, top: 100, end: 200, bottom: 300),
                              //     items: [
                              //       PopupMenuItem(
                              //           child: getAlert() // short press form
                              //       )
                              //     ]
                              //   );
                              },
                              onTapUp: (_) {
                                if (!isLongPressed) {
                                  print("Is a onTap event");
                                }
                                else {
                                  isLongPressed = false;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (img.type == AssetType.video)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return Container();
              }
            }
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      PhotoManager.openSetting();
    }
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
                  ),
                ]
            ),
          ),
        ),
      ),
        // Placeholder for a popup microphone when recording starts
        body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return true;
        },
        child: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return _mediaList[index];
            }),
      )
    );
  }
}


