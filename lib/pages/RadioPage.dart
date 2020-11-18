//import 'package:audioplayers/audioplayers.dart';
import 'package:faithradio/routes/Router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume/volume.dart';
//import 'package:share/share.dart';
import 'RadioContext.dart';
import 'package:flutter/services.dart' as Service;

MaterialColor colorTheme = MaterialColor(0XFF300030, {
  0: Color(0X00300030),
  50: Color(0XF0300030),
  100: Color(0XF0300030),
  200: Color(0XF0300030),
  300: Color(0XF0300030),
  500: Color(0XF0300030),
  600: Color(0XF0300030),
  700: Color(0XF0300030),
  800: Color(0XF0300030),
  900: Color(0XF0300030)
});

class RadioPage extends StatefulWidget {
  RadioPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  double volume = 1;
  int volumeMax = 15;
  AudioManager audioManager;

  void switchState() {
//    if(audioPlayer.)
    //audioPlayer = new AudioPlayer();
    /*audioPlayer.play('http://icecast.skyrock.net/s/parisidf_aac_96k').then((statut){
      if(statut == 1){
        print("Lecture Ok ${audioPlayer.playerId}");
      }else
        print("lecture KO");
    });
    */
    close();
  }

  openDrawer() {
    if (!key.currentState.isDrawerOpen) {
      key.currentState.openDrawer();
    }
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  setVolume(double d) {
    setVol(d.toInt());
    updateVolumes();
    //RadioContext.audioPlayer.setVolume(d/volumeMax);
    Volume.setVol(d.toInt());
    setState(() {
      volume = d;
    });
  }

  startPlaying() {
    RadioContext.audioPlayer.play().then((state) {
      // if(state == 1){
      print('Lecture Ok');
      setState(() {
        RadioContext.isPlay = true;
      });
      //}else{
      print("Impossible de mettre sur play ");
      //}
    }).catchError((error) {
      print("\n\n\nError = $error");
    });
    print('volume');
  }

  setPlayPause() {
    close();

    // if(RadioContext.isStop == true){
    //   RadioContext.audioPlayer.play().then((state){
    //    // if(state == 1){
    //       print('Lecture Ok');
    //       setState(() {
    //        RadioContext.isPlay = true;
    //       });
    //     //}else{
    //       print("Impossible de mettre sur play");
    //     //}
    //   });
    // }else{
    //   if(RadioContext.isPlay == true){
    //     RadioContext.audioPlayer.pause().then((state){
    //      // if(state == 1)
    //         setState(() {
    //           RadioContext.isPlay = false;
    //         });
    //       //else{
    //         print("impossible de mettre en pause");
    //       //}
    //     });
    //   }else{
    //     RadioContext.audioPlayer.play();
    //   }
    // }
    // RadioContext.isStop = false;
  }

  followOn(String socialMedia) async {
    String uri;
    switch (socialMedia) {
      case 'Facebook':
        uri = RadioContext.facebook;
        break;
      case 'Twitter':
        uri = RadioContext.twitter;
        break;
      case 'Instagram':
        uri = RadioContext.instagram;
        break;
      case 'Youtube':
        uri = RadioContext.youtube;
        break;
      case 'Email':
        uri = RadioContext.mail;
        break;
      case 'Phone':
        uri = 'tel:+237 6 78 78 16 21';
        break; //; +237 2 42 00 20 09; +237 2 22 31 03 24'; break;
      case 'Web':
        uri = RadioContext.webSite;
        break;
      default:
        uri = 'sms:+237 698 12 81 55';
    }
    if (await canLaunch(uri) == true) {
      await launch(uri, forceWebView: false, forceSafariVC: false);
    } else {
      print("Impossible de charger l'uri $uri");
    }
  }

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager.STREAM_SYSTEM;
    initPlatformState();
    updateVolumes();

    RadioContext.audioPlayer
        .setUrl(RadioContext.stream)
        .then((_) => startPlaying())
        .catchError((error) => noInternet());

    Service.RawKeyboard.instance.addListener((Service.RawKeyEvent e) {
      if (e.physicalKey.hashCode ==
              Service.PhysicalKeyboardKey.audioVolumeUp.hashCode ||
          e.physicalKey.hashCode ==
              Service.PhysicalKeyboardKey.audioVolumeDown.hashCode)
        Volume.getVol.then((value) {
          setVolume(value * 1.0);
        });
    });
  }

  updateVolumes() async {
    // get Max Volume
    volumeMax = await Volume.getMaxVol;
    // get Current Volume
    volume = await Volume.getVol * 1.0;
    setState(() {});
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_SYSTEM);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //AudioPlayer.logEnabled = false;
    //audioPlayer.onPlayerError.listen((error)=>print("error $error"));
    Volume.controlVolume(AudioManager.STREAM_MUSIC);
    Volume.getMaxVol.then((max) => volumeMax = max);

    Map<String, TextStyle> style = {
      "bigger": TextStyle(fontSize: size.width * .18, color: Colors.black54),
      "title": TextStyle(fontSize: 25, color: Colors.black54),
      "smaller": TextStyle(fontSize: 30, color: Colors.black54)
    };

    return WillPopScope(
        child: Scaffold(
            key: key,
            drawer: Container(
              width: size.width - 100,
              height: size.height,
              decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.colorBurn,
                  color: colorTheme.withOpacity(0.3)),
            ),
            body: SingleChildScrollView(
                child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/cardio1.jpg"), fit: BoxFit.cover),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Color(0xF08badba)),
                  ),
                  Positioned(
                    child: FlatButton(
                      child: Icon(
                        Icons.power_settings_new,
                        color: RadioContext.appState == AppState.POWER_OFF
                            ? Colors.white54
                            : Colors.greenAccent,
                        size: 30,
                      ),
                      onPressed: switchState,
                    ),
                    right: 5,
                    top: 25,
                  ),
                  Positioned(
                    child: Material(
                        color: Colors.transparent,
                        child: Hero(
                            child: Container(
                              child: Center(
                                child:
                                    Text("Faith Radio", style: style["title"]),
                                //heightFactor: 100,
                              ),
                              //width: size.width,
                            ),
                            tag: "TabernacleRadioTitle",
                            transitionOnUserGestures: true)),
                    left: 100,
                    top: 35,
                  ),
                  Positioned(
                    child: Center(
                        child: Column(children: [
                      Text("99.0", style: style["bigger"]),
                      Text("FAITH RADIO 99.0 FM", style: style["smaller"]),
                      Container(
                          width: size.width,
                          padding: EdgeInsets.all(20),
                          child: Row(children: [
                            IconButton(
                                icon: Icon(Icons.volume_down),
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () => setVolume(0)),
                            SizedBox(
                              child: Slider(
                                onChanged: setVolume,
                                value: volume,
                                max: volumeMax / 1.0,
                                divisions: 10,
                                semanticFormatterCallback: (d) =>
                                    d % 2 == 0 ? "$d" : "",
                                activeColor: Colors.black54,
                                inactiveColor: Colors.black38,
                                min: 0,
                                label: "${volume.toInt()}",
                              ),
                              width: size.width - 200,
                            ),
                            IconButton(
                                icon: Icon(Icons.volume_up),
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () => setVolume(volumeMax * 1.0))
                          ])),
                      Hero(
                        child: Card(
                          color: Colors.black45,
                          child: Column(children: <Widget>[
                            ListTile(
                              trailing: FlatButton(
                                  child: Icon(MdiIcons.shareVariant,
                                      color: Color(0xFF8badba)),
                                  onPressed:
                                      null // () => Share.share("Visitez notre sitweb ${RadioContext.webSite}")
                                  ),
                              title: Text(
                                "Suivez-nous",
                                style: TextStyle(
                                    color: Color(0xFF8badba), fontSize: 25),
                              ),
                            ),
                            Container(
                                height: 80,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: SafeArea(
                                    child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(MdiIcons.phone,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () => followOn("Phone")),
                                      IconButton(
                                          icon: Icon(MdiIcons.gmail,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () => followOn("Email")),
                                      IconButton(
                                          icon: Icon(MdiIcons.youtubeTv,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () => followOn("Youtube")),
                                      IconButton(
                                          icon: Icon(MdiIcons.facebook,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () =>
                                              followOn("Facebook")),
                                      IconButton(
                                          icon: Icon(MdiIcons.twitter,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () => followOn("Twitter")),
                                      IconButton(
                                          icon: Icon(MdiIcons.instagram,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () =>
                                              followOn("Instagram")),
                                      IconButton(
                                          icon: Icon(MdiIcons.web,
                                              size: 25,
                                              color: Color(0xFF8badba)),
                                          onPressed: () => followOn("Web"))
                                    ],
                                  ),
                                )))
                          ]),
                        ),
                        tag: "TabernacleSocial",
                      ),
                      /* Hero(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF8badba),
                              ),
                              margin: EdgeInsets.only(top: 50),
                              padding: EdgeInsets.only(right: 0),
                              width: size.width*.3,
                              height: size.width*.3,
                              child: FlatButton(
                                child: Icon(Icons.power_settings_new, // RadioContext.isPlay ? Icons.pause : Icons.play_arrow, 
                                  size: size.width*.2, 
                                  color: Colors.black54),
                                onPressed: setPlayPause,
                                ),
                            ),
                            tag: "TabernacleRadioSwitcher",
                            transitionOnUserGestures: true,
                          ),*/
                    ])),
                    top: size.height * .2,
                    left: 10,
                    right: 10,
                  )
                ],
              ),
            ) // This trailing comma makes auto-formatting nicer for build methods.
                )),
        onWillPop: () => close() ?? false);
  }

  close() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              content: Text('Voulez-vous vraiment quiter'),
              actions: <Widget>[
                CupertinoButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      FaithRouter.goBack(context);
                    }),
                SizedBox(width: 100),
                CupertinoButton(
                    child: Text("Quitter"),
                    onPressed: () {
                      RadioContext.audioPlayer.stop();
                      RadioContext.isStop = true;
                      RadioContext.isPlay = false;
                      RadioContext.appState = AppState.POWER_OFF;
                      FaithRouter.goto(context, "/", RouterMode.EMPTY);
                    })
              ],
            ));
  }

  noInternet() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              content: Text('Connexion internet non disponible'),
              actions: <Widget>[
                CupertinoButton(
                    child: Text('Réessayer'),
                    onPressed: () {
                      FaithRouter.goBack(context);
                      setState(() {});
                    }),
                SizedBox(width: 100),
                CupertinoButton(
                    child: Text("Quitter"),
                    onPressed: () {
                      RadioContext.audioPlayer.stop();
                      RadioContext.isStop = true;
                      RadioContext.isPlay = false;
                      RadioContext.appState = AppState.POWER_OFF;
                      FaithRouter.goto(context, "/", RouterMode.EMPTY);
                    })
              ],
            ));
  }
}
