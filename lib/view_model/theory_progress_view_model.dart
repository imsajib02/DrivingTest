import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/theory_progress_interface.dart';
import 'package:ukbangladrivingtest/model/performance.dart';
import 'package:ukbangladrivingtest/repository/question_answer_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';


class TheoryProgressViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = false;
  bool isPractiseMode = false;
  bool isFetched = false;

  PerformanceList performanceList = PerformanceList(list: List());

  PerformanceList practisePerformanceList = PerformanceList(list: List());
  PerformanceList mockPerformanceList = PerformanceList(list: List());

  List<List<String>> indexBanglaList = List();

  List<String> driverTypeList = List();
  List<String> countryList = List();
  List<String> countryBanglaList = List();
  List<String> scoreList = List();
  List<String> scoreBanglaList = List();

  List<List<int>> totalCorrect = List();
  List<List<int>> totalIncorrect = List();
  List<List<int>> flagList = List();

  List<String> bestCategoryList = List();
  List<String> bestCategoryBanglaList = List();
  List<String> worstCategoryList = List();
  List<String> worstCategoryBanglaList = List();

  static const int all = 0;
  static const int correct = 1;
  static const int incorrect = 2;
  static const int flagged = 3;
  int currentIndex = 0;



  Future<void> getPerformanceHistory(TheoryProgressInterface interface) async {

    if(!isDisposed) {

      if(!isFetched) {

        isFetched = true;

        practisePerformanceList.list.clear();
        mockPerformanceList.list.clear();

        performanceList = await QuestionAnswerRepository().getTheoryTestPerformance();

        for(int i=0; i<performanceList.list.length; i++) {

          if(performanceList.list[i].type == Constants.progressTypeList[0]) {

            if(practisePerformanceList.list.length < 10) {

              practisePerformanceList.list.add(performanceList.list[i]);
            }
          }
          else {

            if(mockPerformanceList.list.length < 10) {

              mockPerformanceList.list.add(performanceList.list[i]);
            }
          }
        }

        onModeSelected(true, interface);
      }

      notifyListeners();
    }
  }



  void onModeSelected(bool isPractiseModeSelected, TheoryProgressInterface interface) async {

    if(!isDisposed) {

      driverTypeList.clear();
      countryList.clear();
      countryBanglaList.clear();

      indexBanglaList.clear();

      scoreList.clear();
      scoreBanglaList.clear();
      bestCategoryList.clear();
      bestCategoryBanglaList.clear();
      worstCategoryList.clear();
      worstCategoryBanglaList.clear();

      totalCorrect.clear();
      totalIncorrect.clear();
      flagList.clear();

      if(isPractiseModeSelected && !isPractiseMode) {

        isPractiseMode = true;

        if(practisePerformanceList.list.length > 0) {

          for(int i=0; i<performanceList.list.length; i++) {

            List<int> flags = List();
            List<int> corrects = List();
            List<int> inCorrects = List();

            List<String> banglaIndexes = List();

            Set<int> correctCategoryList = HashSet();
            Set<int> incorrectCategoryList = HashSet();
            List<int> totalCorrectList = List();
            List<int> totalIncorrectList = List();
            List<int> totalCount = List();
            List<int> temp = List();


            for(int j=0; j<practisePerformanceList.list[i].testQuestionList.list.length; j++) {

              banglaIndexes.add(await _translateNumber(j+1));

              if(practisePerformanceList.list[i].testQuestionList.list[j].isFlagged) {
                flags.add(j);
              }

              if(practisePerformanceList.list[i].testQuestionList.list[j].isAnsweredCorrectly) {
                corrects.add(j);
                correctCategoryList.add(practisePerformanceList.list[i].testQuestionList.list[j].categoryID);
                totalCorrectList.add(practisePerformanceList.list[i].testQuestionList.list[j].categoryID);
              }
              else {
                inCorrects.add(j);
                incorrectCategoryList.add(practisePerformanceList.list[i].testQuestionList.list[j].categoryID);
                totalIncorrectList.add(practisePerformanceList.list[i].testQuestionList.list[j].categoryID);
              }
            }


            indexBanglaList.add(banglaIndexes);

            flagList.add(flags);
            totalCorrect.add(corrects);
            totalIncorrect.add(inCorrects);


            if(totalCorrect[i].length > 0) {

              scoreList.add(((100 * totalCorrect[i].length) / performanceList.list[i].testQuestionList.list.length).floor().toString() + "%");
              String score = await _translateNumber(((100 * totalCorrect[i].length) / performanceList.list[i].testQuestionList.list.length).floor());
              scoreBanglaList.add(score + "%");
            }
            else {
              scoreList.add("0%");
              scoreBanglaList.add("০%");
            }


            for(int k=0; k<Constants.userTypeIdList.length; k++) {

              if(Constants.userTypeIdList[k] == performanceList.list[i].testQuestionList.list.first.userTypeID) {

                driverTypeList.add(Constants.userTypeList[k]);
              }
            }


            for(int k=0; k<Constants.countryCodeList.length; k++) {

              if(Constants.countryCodeList[k] == performanceList.list[i].testQuestionList.list.first.countryCode) {

                countryList.add(Constants.countryList[k]);
                countryBanglaList.add(Constants.countryBanglaList[k]);
              }
            }


            if(correctCategoryList.length > 0) {

              for(int k=0; k<correctCategoryList.length; k++) {

                int total = 0;

                for(int l=0; l<totalCorrectList.length; l++) {

                  if(totalCorrectList[l] == correctCategoryList.elementAt(k)) {
                    total = total + 1;
                  }
                }

                totalCount.add(total);
                temp.add(total);
              }
            }
            else {

              for(int k=0; k<incorrectCategoryList.length; k++) {

                int total = 0;

                for(int l=0; l<totalIncorrectList.length; l++) {

                  if(totalIncorrectList[l] == incorrectCategoryList.elementAt(k)) {
                    total = total + 1;
                  }
                }

                totalCount.add(total);
                temp.add(total);
              }
            }


            try {

              temp.sort();

              if(correctCategoryList.length > 0) {

                if(totalCount.length > 1) {

                  bestCategoryList.add(Constants.categories[totalCount.indexOf(temp.last)]);
                  bestCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.last)]);

                  if(totalCount.indexOf(temp.first) == 0) {
                    worstCategoryList.add("");
                    worstCategoryBanglaList.add("");
                  }
                  else {
                    worstCategoryList.add(Constants.categories[totalCount.indexOf(temp.first)]);
                    worstCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.first)]);
                  }
                }
                else {

                  bestCategoryList.add(Constants.categories[correctCategoryList.first]);
                  bestCategoryBanglaList.add(Constants.categoriesBangla[correctCategoryList.first]);
                  worstCategoryList.add("");
                  worstCategoryBanglaList.add("");
                }
              }
              else {

                if(totalCount.length > 1) {

                  bestCategoryList.add("");
                  bestCategoryBanglaList.add("");

                  if(totalCount.indexOf(temp.last) == 0) {
                    worstCategoryList.add("");
                    worstCategoryBanglaList.add("");
                  }
                  else {
                    worstCategoryList.add(Constants.categories[totalCount.indexOf(temp.last)]);
                    worstCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.last)]);
                  }
                }
                else {

                  bestCategoryList.add("");
                  bestCategoryBanglaList.add("");
                  worstCategoryList.add(Constants.categories[incorrectCategoryList.first]);
                  worstCategoryBanglaList.add(Constants.categoriesBangla[incorrectCategoryList.first]);
                }
              }
            }
            catch(error) {}
          }
        }

        interface.showProgressView(practisePerformanceList);
      }
      else if(!isPractiseModeSelected && isPractiseMode) {

        isPractiseMode = false;

        if(mockPerformanceList.list.length > 0) {

          for(int i=0; i<mockPerformanceList.list.length; i++) {

            List<int> flags = List();
            List<int> corrects = List();
            List<int> inCorrects = List();

            Set<int> correctCategoryList = HashSet();
            Set<int> incorrectCategoryList = HashSet();
            List<int> totalCorrectList = List();
            List<int> totalIncorrectList = List();
            List<int> totalCount = List();
            List<int> temp = List();


            for(int j=0; j<mockPerformanceList.list[i].testQuestionList.list.length; j++) {

              if(mockPerformanceList.list[i].testQuestionList.list[j].isFlagged) {
                flags.add(j);
              }

              if(mockPerformanceList.list[i].testQuestionList.list[j].isAnsweredCorrectly) {
                corrects.add(j);
                correctCategoryList.add(mockPerformanceList.list[i].testQuestionList.list[j].categoryID);
                totalCorrectList.add(mockPerformanceList.list[i].testQuestionList.list[j].categoryID);
              }
              else {
                inCorrects.add(j);
                incorrectCategoryList.add(mockPerformanceList.list[i].testQuestionList.list[j].categoryID);
                totalIncorrectList.add(mockPerformanceList.list[i].testQuestionList.list[j].categoryID);
              }
            }


            flagList.add(flags);
            totalCorrect.add(corrects);
            totalIncorrect.add(inCorrects);


            if(totalCorrect[i].length > 0) {

              scoreList.add(((100 * totalCorrect[i].length) / mockPerformanceList.list[i].testQuestionList.list.length).floor().toString() + "%");
              String score = await _translateNumber(((100 * totalCorrect[i].length) / mockPerformanceList.list[i].testQuestionList.list.length).floor());
              scoreBanglaList.add(score + "%");
            }
            else {
              scoreList.add("0%");
              scoreBanglaList.add("০%");
            }


            for(int k=0; k<Constants.userTypeIdList.length; k++) {

              if(Constants.userTypeIdList[k] == mockPerformanceList.list[i].testQuestionList.list.first.userTypeID) {

                driverTypeList.add(Constants.userTypeList[k]);
              }
            }


            for(int k=0; k<Constants.countryCodeList.length; k++) {

              if(Constants.countryCodeList[k] == mockPerformanceList.list[i].testQuestionList.list.first.countryCode) {

                countryList.add(Constants.countryList[k]);
                countryBanglaList.add(Constants.countryBanglaList[k]);
              }
            }


            if(correctCategoryList.length > 0) {

              for(int k=0; k<correctCategoryList.length; k++) {

                int total = 0;

                for(int l=0; l<totalCorrectList.length; l++) {

                  if(totalCorrectList[l] == correctCategoryList.elementAt(k)) {
                    total = total + 1;
                  }
                }

                totalCount.add(total);
                temp.add(total);
              }
            }
            else {

              for(int k=0; k<incorrectCategoryList.length; k++) {

                int total = 0;

                for(int l=0; l<totalIncorrectList.length; l++) {

                  if(totalIncorrectList[l] == incorrectCategoryList.elementAt(k)) {
                    total = total + 1;
                  }
                }

                totalCount.add(total);
                temp.add(total);
              }
            }


            try {

              temp.sort();

              if(correctCategoryList.length > 0) {

                if(totalCount.length > 1) {

                  bestCategoryList.add(Constants.categories[totalCount.indexOf(temp.last)]);
                  bestCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.last)]);

                  if(totalCount.indexOf(temp.first) == 0) {
                    worstCategoryList.add("");
                    worstCategoryBanglaList.add("");
                  }
                  else {
                    worstCategoryList.add(Constants.categories[totalCount.indexOf(temp.first)]);
                    worstCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.first)]);
                  }
                }
                else {

                  bestCategoryList.add(Constants.categories[correctCategoryList.first]);
                  bestCategoryBanglaList.add(Constants.categoriesBangla[correctCategoryList.first]);
                  worstCategoryList.add("");
                  worstCategoryBanglaList.add("");
                }
              }
              else {

                if(totalCount.length > 1) {

                  bestCategoryList.add("");
                  bestCategoryBanglaList.add("");

                  if(totalCount.indexOf(temp.last) == 0) {
                    worstCategoryList.add("");
                    worstCategoryBanglaList.add("");
                  }
                  else {
                    worstCategoryList.add(Constants.categories[totalCount.indexOf(temp.last)]);
                    worstCategoryBanglaList.add(Constants.categoriesBangla[totalCount.indexOf(temp.last)]);
                  }
                }
                else {

                  bestCategoryList.add("");
                  bestCategoryBanglaList.add("");
                  worstCategoryList.add(Constants.categories[incorrectCategoryList.first]);
                  worstCategoryBanglaList.add(Constants.categoriesBangla[incorrectCategoryList.first]);
                }
              }
            }
            catch(error) {}
          }
        }

        interface.showProgressView(mockPerformanceList);
      }

      notifyListeners();
    }
  }



  void setTab(int index) {

    if(!isDisposed) {

      switch (index) {

        case all:
          currentIndex = all;
          break;

        case correct:
          currentIndex = correct;
          break;

        case incorrect:
          currentIndex = incorrect;
          break;

        case flagged:
          currentIndex = flagged;
          break;

        default:
          currentIndex = all;
          break;
      }

      notifyListeners();
    }
  }



  Future<String> _translateNumber(int index) async {

    String indexInBangla = "";

    for(int i=0; i<index.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(index.toString()[i] == Constants.englishNumeric[j]) {

          indexInBangla = indexInBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return indexInBangla;
  }



  Future<void> resetScore(TheoryProgressInterface interface) async {

    if(!isDisposed) {

      await QuestionAnswerRepository().resetTheoryTestPerformance();

      performanceList.list.clear();
      practisePerformanceList.list.clear();
      mockPerformanceList.list.clear();

      driverTypeList.clear();
      countryList.clear();
      countryBanglaList.clear();

      scoreList.clear();
      scoreBanglaList.clear();
      bestCategoryList.clear();
      bestCategoryBanglaList.clear();
      worstCategoryList.clear();
      worstCategoryBanglaList.clear();

      totalCorrect.clear();
      totalIncorrect.clear();
      flagList.clear();

      indexBanglaList.clear();

      interface.resetView();

      notifyListeners();
    }
  }



  Future<void> resetModel() async {

    isDisposed = true;
    isPractiseMode = false;
    isFetched = false;

    performanceList.list.clear();
    practisePerformanceList.list.clear();
    mockPerformanceList.list.clear();

    driverTypeList.clear();
    countryList.clear();
    countryBanglaList.clear();

    scoreList.clear();
    scoreBanglaList.clear();
    bestCategoryList.clear();
    bestCategoryBanglaList.clear();
    worstCategoryList.clear();
    worstCategoryBanglaList.clear();

    totalCorrect.clear();
    totalIncorrect.clear();
    flagList.clear();

    indexBanglaList.clear();

    currentIndex = all;

    if(!isDisposed) {
      notifyListeners();
    }
  }



  Future<void> resetCurrentTab() async {

    if(!isDisposed) {
      currentIndex = all;
      notifyListeners();
    }
  }



  @override
  void removeDisposedStatus() {

    if(isDisposed) {
      isDisposed = false;
    }
  }
}