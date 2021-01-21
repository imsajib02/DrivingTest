import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/no_connection_interface.dart';
import 'package:ukbangladrivingtest/interace/video_flag_interface.dart';
import 'package:ukbangladrivingtest/model/hazard_video.dart';
import 'package:ukbangladrivingtest/repository/hazard_perception_repository.dart';
import 'package:ukbangladrivingtest/utils/api_routes.dart';
import 'package:ukbangladrivingtest/utils/connection_check.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:ukbangladrivingtest/utils/parse_duration.dart';
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';

//import 'package:video_thumbnail/video_thumbnail.dart';


class HazardPractiseViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = true;
  bool isFetched = false;
  bool isStoredDataFetched = false;
  bool spoke = false;

  double perBlock = 0.0;

  int selectedVideoIndex = 0;

  Set<int> secondFlags = Set();

  List<Uint8List> thumbnails = List();

  List<List<Offset>> rangeList = List();

  HazardClips storedHazardClips = HazardClips(clipList: List());

  FlutterTts flutterTts = FlutterTts();



  Future<void> getStoredHazardClips() async {

    if(!isStoredDataFetched) {

      isStoredDataFetched = true;
      storedHazardClips = await HazardPerceptionRepository().getHazardClipDetails();
    }
  }



  void getHazardVideos(NoConnectionInterface interface) {

    if(!isDisposed) {

      if(!isFetched) {

        isFetched = true;

        checkInternetConnection().then((isConnected) {

          if(isConnected) {

            var client = http.Client();

            client.get(

              Uri.encodeFull(APIRoute.HAZARD_PERCEPTION_VIDEOS),
              headers: {"Accept" : "application/json"},

            ).then((response) {

              if(response.statusCode == 200 || response.statusCode == 201) {

                List clips = json.decode(response.body);
                //hazardClips = HazardClips.fromJson(json.decode(response.body));

                if(storedHazardClips.clipList.length > 0) {

                  clips.forEach((clip) async {

                    bool match = false;

                    for(int i=0; i<storedHazardClips.clipList.length; i++) {

                      if(clip['clip_path'] == storedHazardClips.clipList[i].clipUrl) {

                        match = true;
                        break;
                      }
                    }

                    if(!match) {

                      await HazardPerceptionRepository().saveHazardClipDetails(json.encode(clip));
                      //hazardClips.add(HazardClip.fromJson(clip, id));
                    }
                  });
                }
                else {

                  clips.forEach((clip) async {

                    await HazardPerceptionRepository().saveHazardClipDetails(json.encode(clip));
                    //hazardClips.add(HazardClip.fromJson(clip, id));
                  });
                }

                showContent(interface);
              }
              else {
                isFetched = false;
              }

            }).timeout(Duration(seconds: 15), onTimeout: () {

              client.close();
              isFetched = false;
            });
          }
          else {

            if(storedHazardClips.clipList.length > 0) {

              showContent(interface);
            }
            else {

              isFetched = false;
              interface.onNoConnection();
            }
          }
        });
      }

      //notifyListeners();
    }
  }



  Future<void> showContent(NoConnectionInterface interface) async {

    if(!isDisposed) {

      isStoredDataFetched = false;
      await getStoredHazardClips();

      for(int i=0; i<storedHazardClips.clipList.length; i++) {

//        final bytes = await VideoThumbnail.thumbnailData(
////            video: storedHazardClips.clipList[i].clipUrl,
////            timeMs: 100,
////            imageFormat: ImageFormat.PNG, maxHeight: 50);
////
////        thumbnails.add(bytes);

//        var file = await DefaultCacheManager().getSingleFile(storedHazardClips.clipList[i].clipUrl);
//
//        thumbnails.add(file);
//        print(file.basename);

        var file = await DefaultCacheManager().getFileFromCache(storedHazardClips.clipList[i].clipUrl);

        if(file == null) {

          Uint8List bytes = await VideoThumbnail.getBytes(storedHazardClips.clipList[i].clipUrl);
          DefaultCacheManager().putFile(storedHazardClips.clipList[i].clipUrl, bytes, maxAge: Duration(days: 365));
          thumbnails.add(bytes);
        }
        else {

          Uint8List bytes = await file.file.readAsBytes();
          thumbnails.add(bytes);
        }
      }

      interface.showContent();
      notifyListeners();
    }
  }



  void onVideoSelected(int index, NoConnectionInterface interface) {

    if(!isDisposed) {

      selectedVideoIndex = index;
      secondFlags.clear();
      rangeList.clear();

      perBlock = (205.1 * SizeConfig.widthSizeMultiplier) / storedHazardClips.clipList[selectedVideoIndex].clipDuration.inSeconds;

      for(int i=0; i<storedHazardClips.clipList[selectedVideoIndex].detailsList.length; i++) {

        List<Offset> offsets = List();

        int startFrame = storedHazardClips.clipList[selectedVideoIndex].detailsList[i].startFrame.inSeconds;
        int endFrame = storedHazardClips.clipList[selectedVideoIndex].detailsList[i].endFrame.inSeconds;

        for(int j=startFrame; j<=endFrame; j++) {

          offsets.add(Offset((perBlock * j) - (perBlock / 2), 0.0));
        }

        rangeList.add(offsets);
      }

      interface.openVideo(storedHazardClips.clipList[index].clipUrl);
    }
  }



  void onTap(Duration position, VideoFlagInterface interface) {

    if(!isDisposed) {

      if(position.inSeconds != storedHazardClips.clipList[selectedVideoIndex].clipDuration.inSeconds) {

        secondFlags.add(position.inSeconds);

        //perBlock = (205.1 * SizeConfig.widthSizeMultiplier) / storedHazardClips.clipList[selectedVideoIndex].clipDuration.inSeconds;
        interface.setFlag(Offset((perBlock * position.inSeconds) - (perBlock / 2), 0.0));
      }
    }
  }



  Future<void> calculateScore(VideoFlagInterface interface) async {

    if(!isDisposed) {

      int score = 0;

      for(int i=0; i<storedHazardClips.clipList[selectedVideoIndex].detailsList.length; i++) {

        int startFrameInSec = storedHazardClips.clipList[selectedVideoIndex].detailsList[i].startFrame.inSeconds;
        int endFrameInSec = storedHazardClips.clipList[selectedVideoIndex].detailsList[i].endFrame.inSeconds;

        MIDDLE: for(int j=0; j<secondFlags.length; j++) {

          for(int k=startFrameInSec; k<=endFrameInSec; k++) {

            if(secondFlags.elementAt(j) == k) {

              score = score + (storedHazardClips.clipList[selectedVideoIndex].detailsList[i].totalMarks - (k - startFrameInSec));
              break MIDDLE;
            }
          }
        }
      }

      score = (score / storedHazardClips.clipList[selectedVideoIndex].detailsList.length).round();

      storedHazardClips.clipList[selectedVideoIndex].score = score;
      storedHazardClips.clipList[selectedVideoIndex].scoreInBangla = await _translateNumber(score);

      await HazardPerceptionRepository().saveHazardClipScore(storedHazardClips.clipList[selectedVideoIndex]);

      notifyListeners();
      interface.onPractiseComplete();
    }
  }



  Future<String> _translateNumber(int number) async {

    String inBangla = "";

    for(int i=0; i<number.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number.toString()[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }



  Future speak(String description, bool isEnglish) async {

    if(!isDisposed) {

      if(!spoke) {

        spoke = true;

        await flutterTts.stop();

        await flutterTts.setPitch(1);
        await flutterTts.setVolume(1.0);

        if(isEnglish) {
          await flutterTts.setLanguage("en-US");
        }
        else {
          await flutterTts.setLanguage("bn-BD");
        }

        await flutterTts.speak(description);
      }
    }
  }



  Future stopSpeaking() async {

    if(!isDisposed) {
      await flutterTts.stop();
    }
  }



  void removeSpokeStatus() {

    if(!isDisposed) {

      if(spoke) {

        spoke = false;
        notifyListeners();
      }
    }
  }



  void resetModel() async {

    isDisposed = true;
    isFetched = false;
    isStoredDataFetched = false;
    spoke = false;

    perBlock = 0.0;

    selectedVideoIndex = 0;

    //storedHazardClips.clipList.clear();
    thumbnails.clear();
    secondFlags.clear();
    rangeList.clear();

    if(!isDisposed) {
      notifyListeners();
    }
  }



  @override
  void removeDisposedStatus() {

    if(isDisposed) {
      isDisposed = false;
    }

    notifyListeners();
  }
}