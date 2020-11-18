
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:url_audio_stream/url_audio_stream.dart';

enum AppState{
  POWER_ON,
  POWER_OFF
}

class RadioContext  {
  static AppState appState = AppState.POWER_OFF;

//  static AudioStream audioPlayer = new AudioStream(stream);
//  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioPlayer audioPlayer = AudioPlayer();

  static bool isStop = true;

  static bool isPlay = false;

  static String webSite = 'https:/www.na-ministry.org',
                phone = 'tel:+237 6 78 78 16 21',
                facebook = 'https://www.facebook.com/Gloire-céleste-104916684571590',
                instagram = 'https://www.instagram.com/ngoaatanganaf/',
                twitter = 'https://twitter.com/MPCAFTL',
                youtube = 'https://www.youtube.com/channel/UCsopSo_ymrBGTov84zCqSog',
                mail = 'mailto:mpcaftl@gmail.com',
                stream = 'https://stream.radio.co/s8ffd978a6/listen';
}
