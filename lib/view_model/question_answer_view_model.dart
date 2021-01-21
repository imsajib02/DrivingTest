import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/question_answer_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/repository/question_answer_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:collection';


class QuestionAnswerViewModel extends ChangeNotifier implements BasicViewModel {

  String language = "";
  String stringNumber = "";
  String totalQuestion = "";

  int languageID = 0;
  int number = 0;

  bool autoMoveToNext = false;
  bool isIncorrectAlertActive = false;
  bool isDataFetched = false;
  bool isDisposed = false;
  bool isVoiceActivated = false;

  FlutterTts flutterTts = FlutterTts();

  TheoryTestQuestionList testQuestionList = TheoryTestQuestionList(list: List());
  List<int> flagList = List();



  void alterLanguage() {

    if(!isDisposed) {

      if(languageID != 0) {

        switch(languageID) {

          case 1:
            QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[1]);
            break;

          case 2:
            QuestionAnswerRepository().setQuestionAnswerLanguage(Constants.questionAnswerLanguageIdList[0]);
            break;
        }
      }

      notifyListeners();
    }
  }



  void getAnsweringLanguage(BuildContext context) async {

    if(!isDisposed) {

      languageID = await QuestionAnswerRepository().getQuestionAnswerLanguage();

      switch(languageID) {

        case 1:
          language = AppLocalization.of(context).getTranslatedValue("en");
          break;

        case 2:
          language = AppLocalization.of(context).getTranslatedValue("bn");
          break;
      }

      notifyListeners();
    }
  }



  void getAutoMoveStatus() async {

    if(!isDisposed) {
      autoMoveToNext = await QuestionAnswerRepository().getAutoMoveStatus();
      notifyListeners();
    }
  }



  void getIncorrectAlert() async {

    if(!isDisposed) {
      isIncorrectAlertActive = await QuestionAnswerRepository().getIncorrectAlert();
      notifyListeners();
    }
  }



  void setVoiceOverStatus() async {

    if(!isDisposed) {

      QuestionAnswerRepository().setVoiceOverStatus(!isVoiceActivated);
      await flutterTts.stop();
      notifyListeners();
    }
  }



  void getVoiceOverStatus() async {

    if(!isDisposed) {
      isVoiceActivated = await QuestionAnswerRepository().getVoiceOverStatus();
      notifyListeners();
    }
  }



  void getQuestions(List<bool> categorySelection, QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      if(!isDataFetched) {

        isDataFetched = true;
        testQuestionList = await QuestionAnswerRepository().getQuestions(categorySelection);
        totalQuestion = await _translateNumber(testQuestionList.list.length);
        increaseNumber(questionAnswerInterface);
      }

      notifyListeners();
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



  Future<void> onFavPressed() async {

    if(!isDisposed) {

      testQuestionList.list[number-1].isMarkedFavourite = !testQuestionList.list[number-1].isMarkedFavourite;
      await QuestionAnswerRepository().setFavouriteStatus(testQuestionList.list[number-1]);

      notifyListeners();
    }
  }



  void onFlagPressed() {

    if(!isDisposed) {
      testQuestionList.list[number-1].isFlagged = !testQuestionList.list[number-1].isFlagged;
      notifyListeners();
    }
  }




  Future<void> increaseNumber(QuestionAnswerInterface questionAnswerInterface) async {

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
        questionAnswerInterface.addAnswers(testQuestionList.list[number-1]);
        speak(true);
      }

      stringNumber = await _translateNumber(number);

      notifyListeners();
    }
  }



  Future<void> decreaseNumber(QuestionAnswerInterface questionAnswerInterface) async {

    if(!isDisposed) {

      if(!testQuestionList.list[number-1].isCorrectAnswerShown && !testQuestionList.list[number-1].isFlagged) {
        testQuestionList.list[number-1].optionAnswered = 0;
      }

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
        questionAnswerInterface.removeLastAnswer();
        speak(true);
      }

      stringNumber = await _translateNumber(number);

      notifyListeners();
    }
  }



  void setCorrectAnswerShownStatus() {

    if(!isDisposed) {
      testQuestionList.list[number-1].isCorrectAnswerShown = true;
      notifyListeners();
    }
  }



  void setOptionAnswered(int choice) {

    if(!isDisposed) {
      testQuestionList.list[number-1].optionAnswered = choice;
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



  Future speak(bool isQuestion) async {

    if(!isDisposed) {

      if(isVoiceActivated) {

        if(languageID != 0) {

          await flutterTts.stop();

          await flutterTts.setPitch(0.3);
          await flutterTts.setVolume(1.0);

          languageID == 1 ? await flutterTts.setLanguage("en-US") : await flutterTts.setLanguage("bn-BD");

          if(isQuestion) {

            if(isVoiceActivated) {
              languageID == 1 ? await flutterTts.speak(testQuestionList.list[number-1].question) : await flutterTts.speak(testQuestionList.list[number-1].questionInBangla);
            }
          }
          else {

            if(isVoiceActivated) {
              languageID == 1 ? await flutterTts.speak(testQuestionList.list[number-1].explanation) : await flutterTts.speak(testQuestionList.list[number-1].explanationInBangla);
            }
          }
        }
      }
    }
  }



  void onFinished(QuestionAnswerInterface questionAnswerInterface) {

    if(!isDisposed) {

      flagList.clear();

      int correct = 0;
      int incorrect = 0;

      Set<int> correctCategoryList = HashSet();
      List<int> totalCorrectList = List();

      for(int i=0; i<testQuestionList.list.length; i++) {

        if(testQuestionList.list[i].isFlagged) {
          flagList.add(i);
        }

        testQuestionList.list[i].isAnswered = true;


        if(testQuestionList.list[i].optionAnswered == testQuestionList.list[i].correctAnswer) {

          testQuestionList.list[i].isAnsweredCorrectly = true;
          correct = correct + 1;
          correctCategoryList.add(testQuestionList.list[i].categoryID);
          totalCorrectList.add(testQuestionList.list[i].categoryID);
        }
        else {

          testQuestionList.list[i].isAnsweredCorrectly = false;
          incorrect = incorrect + 1;
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

      await QuestionAnswerRepository().saveTestResult(testQuestionList, Constants.progressTypeList[0]);
      questionAnswerInterface.showTestResult();
    }
  }



  Future<void> resetModel() async {

    isDisposed = true;

    language = "";
    stringNumber = "";
    totalQuestion = "";

    languageID = 0;
    number = 0;

    autoMoveToNext = false;
    isDataFetched = false;
    isVoiceActivated = false;
    isIncorrectAlertActive = false;

    flagList.clear();
    //testQuestionList.list.clear();

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