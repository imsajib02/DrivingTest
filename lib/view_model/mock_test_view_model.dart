import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/question_answer_interface.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/repository/question_answer_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';


class MockTestViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = true;
  bool isDataFetched = false;
  bool isBackPressed = false;

  int number = 0;
  int count = 0;
  int remainingTime = 0;

  String totalQuestion = "";
  String stringNumber = "০";

  TheoryTestQuestionList questionList = TheoryTestQuestionList(list: List());
  List<int> flagList = List();

  Timer _timer;
  FlutterTts flutterTts = FlutterTts();



  Future<void> getMockTestQuestions() async {

    if(!isDisposed) {

      if(!isDataFetched) {
        isDataFetched = true;
        questionList = await QuestionAnswerRepository().getMockQuestions();
        totalQuestion = await _translateNumber(questionList.list.length);
      }
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



  Future<void> startTest(QuestionAnswerInterface questionAnswerInterface, BuildContext context) async {

    if(!isDisposed) {

      if(count < 1) {

        count = count + 1;
        number = number + 1;
        stringNumber = await _translateNumber(number);

        questionAnswerInterface.addAnswers(questionList.list[number-1]);

        startTimer(questionAnswerInterface);

        speak(true, context);
        notifyListeners();
      }
    }
  }



  void startTimer(QuestionAnswerInterface questionAnswerInterface) {

    if(!isDisposed) {

      remainingTime = Constants.testDuration;

      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {

        if(remainingTime == 0) {

          timer.cancel();
          saveTestResults(questionAnswerInterface);
        }
        else if(remainingTime > 0) {

          if(!isBackPressed) {

            remainingTime = remainingTime - 1;
            questionAnswerInterface.showRemainingTime(remainingTime);
          }
        }
      });

      notifyListeners();
    }
  }



  void setBackPressStatus() {

    if(!isDisposed) {
      isBackPressed = !isBackPressed;
    }
  }



  Future<void> increaseNumber(QuestionAnswerInterface questionAnswerInterface, BuildContext context) async {

    if(!isDisposed) {

      if(flagList.length > 0) {

        for(int i=0; i<flagList.length; i++) {

          if(number == flagList[i] + 1) {

            number = flagList[i+1] + 1;
            break;
          }
        }
      }
      else {

        number = number + 1;
        questionAnswerInterface.addAnswers(questionList.list[number-1]);
        speak(true, context);
      }

      stringNumber = await _translateNumber(number);

      notifyListeners();
    }
  }



  Future<void> decreaseNumber(QuestionAnswerInterface questionAnswerInterface, BuildContext context) async {

    if(!isDisposed) {

      if(flagList.length > 0) {

        for(int i=0; i<flagList.length; i++) {

          if(number == flagList[i] + 1) {

            number = flagList[i-1] + 1;
            break;
          }
        }
      }
      else {

        number = number - 1;
        speak(true, context);
      }

      stringNumber = await _translateNumber(number);

      notifyListeners();
    }
  }



  Future<void> onFavPressed() async {

    if(!isDisposed) {

      questionList.list[number-1].isMarkedFavourite = !questionList.list[number-1].isMarkedFavourite;
      //await QuestionAnswerRepository().setFavouriteStatus(questionList.list[number-1]);
      notifyListeners();
    }
  }



  Future<void> onFlagPressed() async {

    if(!isDisposed) {

      questionList.list[number-1].isFlagged = !questionList.list[number-1].isFlagged;
      //await QuestionAnswerRepository().setFlagStatus(questionList.list[number-1]);
      notifyListeners();
    }
  }



  Future speak(bool isQuestion, BuildContext context) async {

    if(!isDisposed) {

      if(Provider.of<QuestionViewModel>(context, listen: true).isVoiceActivated) {

        if(Provider.of<QuestionViewModel>(context, listen: true).languageID != 0) {

          await flutterTts.stop();

          await flutterTts.setPitch(0.3);
          await flutterTts.setVolume(1.0);

          Provider.of<QuestionViewModel>(context, listen: true).languageID == 1 ?
          await flutterTts.setLanguage("en-US") : await flutterTts.setLanguage("bn-BD");

          if(isQuestion) {

            if(Provider.of<QuestionViewModel>(context, listen: true).isVoiceActivated) {

              Provider.of<QuestionViewModel>(context, listen: true).languageID == 1 ?
              await flutterTts.speak(questionList.list[number-1].question) : await flutterTts.speak(questionList.list[number-1].questionInBangla);
            }
          }
          else {

            if(Provider.of<QuestionViewModel>(context, listen: true).isVoiceActivated) {

              Provider.of<QuestionViewModel>(context, listen: true).languageID == 1 ?
              await flutterTts.speak(questionList.list[number-1].explanation) : await flutterTts.speak(questionList.list[number-1].explanationInBangla);
            }
          }
        }
      }
    }
  }



  void setOptionAnswered(int choice) {

    if(!isDisposed) {

      questionList.list[number-1].optionAnswered = choice;

      questionList.list[number-1].isAnswered = true;

      if(questionList.list[number-1].optionAnswered == questionList.list[number-1].correctAnswer) {
        questionList.list[number-1].isAnsweredCorrectly = true;
      }
      else {
        questionList.list[number-1].isAnsweredCorrectly = false;
      }

      notifyListeners();
    }
  }



  Future<void> setFlaggedNumber() async {

    if(!isDisposed) {
      number = flagList[0] + 1;
      stringNumber = await _translateNumber(number);
      notifyListeners();
    }
  }



  void onFinished(QuestionAnswerInterface questionAnswerInterface) {

    if(!isDisposed) {

      flagList.clear();

      for(int i=0; i<questionList.list.length; i++) {

        if(questionList.list[i].isFlagged) {
          flagList.add(i);
        }
      }

      if(flagList.length > 0) {
        questionAnswerInterface.showFlaggedQuestionAlert();
      }
      else {
        saveTestResults(questionAnswerInterface);
      }
    }
  }



  Future<void> saveTestResults(QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      await QuestionAnswerRepository().saveTestResult(questionList, Constants.progressTypeList[1]);
      questionAnswerInterface.showTestResult();
    }
  }



  Future<void> resetModel() async {

    isDisposed = true;
    isBackPressed = false;
    isDataFetched = false;

    number = 0;
    count = 0;
    remainingTime = 0;

    totalQuestion = "";
    stringNumber = "০";

    try {
      _timer.cancel();
    }
    catch (error){

    }

    //questionList.list.clear();
    flagList.clear();

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