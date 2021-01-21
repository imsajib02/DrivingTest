import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/localization_constrants.dart';
import 'package:ukbangladrivingtest/repository/settings_repository.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';

import '../main.dart';


class SettingsViewModel extends ChangeNotifier {

  bool isSoundOn = false;
  bool isEnglish = false;

  LocalMemory _localMemory = LocalMemory();


  void getSoundStatus() async {

    isSoundOn = await SettingsRepository().getSoundStatus();
    notifyListeners();
  }


  void setSoundStatus() async {

    isSoundOn = !isSoundOn;

    playSound();

    SettingsRepository().setSoundStatus(isSoundOn);
    notifyListeners();
  }


  Future<void> playSound() async {

    if(isSoundOn) {
      final assetsAudioPlayer = AssetsAudioPlayer();

      assetsAudioPlayer.open(
        Audio("assets/audio/hint_click.wav"),
      );
    }
  }


  void getLanguage() {

    _localMemory.getLanguageCode().then((locale) {
      setMarker(locale);
    });
  }


  Future<void> changeLanguage(BuildContext context, String languageCode) async {

    _localMemory.saveLanguageCode(languageCode).then((locale) {

      MyApp.setLocale(context, locale);
    });
  }


  void setMarker(Locale locale) {

    if(locale.languageCode == ENGLISH) {

      isEnglish = true;
    }
    else if(locale.languageCode == BANGLA) {

      isEnglish = false;
    }

    notifyListeners();
  }
}