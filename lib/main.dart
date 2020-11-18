import 'dart:async';
import 'dart:io';

import 'package:faithradio/routes/Router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';
import 'pages/RadioContext.dart';

void main() {
  runApp(RadioApp());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

MaterialColor colorTheme = MaterialColor(0XFF1f495d, {
  0: Color(0X001f495d),
  50: Color(0XF01f495d),
  100: Color(0XF01f495d),
  200: Color(0XF01f495d),
  300: Color(0XF01f495d),
  500: Color(0XF01f495d),
  600: Color(0XF01f495d),
  700: Color(0XF01f495d),
  800: Color(0XF01f495d),
  900: Color(0XF01f495d)
});

class RadioApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faith Radio',
      theme: ThemeData(
        primarySwatch: colorTheme,
      ),
      onGenerateRoute: FaithRouter.getRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<ConnectivityResult> subscription;

  void switchState() async {
    ConnectivityResult cr = await Connectivity().checkConnectivity();

    if (cr == ConnectivityResult.mobile || cr == ConnectivityResult.wifi) {
      /*setState(() {
      if(RadioContext.appState == AppState.POWER_OFF)
          RadioContext.appState = AppState.POWER_ON;
        else
          RadioContext.appState = AppState.POWER_OFF;
      });*/
      RadioContext.appState = AppState.POWER_ON;
      FaithRouter.goto(context, "/home", RouterMode.PUSH);
    } else {
      Toast.show("Impossible de se connecter à internet", context,
          duration: Toast.LENGTH_LONG);
    }
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
        uri = RadioContext.phone;
        break; //; +237 2 42 00 20 09; +237 2 22 31 03 24'; break;
      case 'Web':
        uri = RadioContext.webSite;
        break;
      default:
        uri = 'sms:+237 698 12 81 55';
    }
    if (await canLaunch(uri) == true) {
      await launch(uri);
    } else {
      print("Impossible de charger l'uri $uri");
    }
  }

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult _) {
      switch (_) {
        case ConnectivityResult.wifi:
          break;

        case ConnectivityResult.mobile:
          break;

        case ConnectivityResult.none:
          RadioContext.audioPlayer.stop();
          RadioContext.isStop = true;
          RadioContext.isPlay = false;
          RadioContext.appState = AppState.POWER_OFF;
          FaithRouter.goto(context, "/", RouterMode.EMPTY);
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, TextStyle> style = {
      "bigger": TextStyle(fontSize: size.width * .18, color: Color(0xFF8badba)),
      "title": TextStyle(fontSize: 30, color: Colors.black54),
      "smaller": TextStyle(fontSize: 30, color: Colors.white)
    };

    return WillPopScope(
      child: CupertinoPageScaffold(
          child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/cardio1.jpg"), fit: BoxFit.cover)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xF08badba)),
            ),
            Positioned(
              child: Material(
                  color: Colors.transparent,
                  child: Hero(
                      child: Container(
                        child: Center(
                          child: Text("Faith Radio 99.0 FM",
                              style: style["title"]),
                          //heightFactor: 100,
                        ),
                        width: MediaQuery.of(context).size.width,
                      ),
                      tag: "TabernacleRadioTitle",
                      transitionOnUserGestures: true)),
              top: 150,
            ),
            Positioned(
              child: Center(
                  child: Column(children: [
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black38,
                    ),
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(right: 0),
                    width: size.width * .3,
                    height: size.width * .3,
                    child: Hero(
                      child: FlatButton(
                        child: Icon(MdiIcons.power,
                            size: size.width * .2,
                            color: RadioContext.appState == AppState.POWER_OFF
                                ? Colors.white70
                                : Colors.white),
                        onPressed: switchState,
                      ),
                      tag: "TabernacleRadioSwitcher",
                      transitionOnUserGestures: true,
                    )),
              ])),
              top: size.height * .3,
              left: 10,
              right: 10,
            ),
            Positioned(
              child: Hero(
                child: Card(
                  color: Colors.black12,
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Text(
                        "Suivez-nous",
                        style:
                            TextStyle(color: Color(0xFF8badba), fontSize: 25),
                      ),
                      trailing: FlatButton(
                          child: Icon(MdiIcons.shareVariant,
                              color: Color(0xFF8badba)),
                          onPressed:
                              null //() => Share.share("Visitez notre sitweb ${RadioContext.webSite}")
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
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Phone")),
                              IconButton(
                                  icon: Icon(MdiIcons.gmail,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Email")),
                              IconButton(
                                  icon: Icon(MdiIcons.youtubeTv,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Youtube")),
                              IconButton(
                                  icon: Icon(MdiIcons.facebook,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Facebook")),
                              IconButton(
                                  icon: Icon(MdiIcons.twitter,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Twitter")),
                              IconButton(
                                  icon: Icon(MdiIcons.instagram,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Instagram")),
                              IconButton(
                                  icon: Icon(MdiIcons.web,
                                      size: 25, color: Color(0xFF8badba)),
                                  onPressed: () => followOn("Web"))
                            ],
                          ),
                        )))
                  ]),
                ),
                tag: "TabernacleSocial",
              ),
              left: 10,
              right: 10,
              bottom: 50, // size.height*.2,
            )
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
      onWillPop: () {
        showCupertinoModalPopup<bool>(
            context: context,
            builder: (_) => new CupertinoAlertDialog(
                  content: Text('Voulez-vous vraiment quitter Faith Radio?'),
                  actions: <Widget>[
                    CupertinoButton(
                        child: Text('Annuler'),
                        onPressed: () {
                          FaithRouter.goBack(context);
                          //exit(0);
                        }),
                    SizedBox(width: 100),
                    CupertinoButton(
                        child: Text("Quitter"),
                        onPressed: () {
                          RadioContext.audioPlayer.stop();
                          RadioContext.isStop = true;
                          RadioContext.isPlay = false;
                          RadioContext.appState = AppState.POWER_OFF;
                          FaithRouter.goBack(context);
                          exit(0);
                        })
                  ],
                  insetAnimationCurve: Curves.elasticIn,
                ));
        return Future<bool>.value(false);
      },
    );
  }
}
