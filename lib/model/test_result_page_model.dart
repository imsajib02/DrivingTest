import 'package:ukbangladrivingtest/model/theory_question.dart';


class TestResultPageModel {

  bool isMockTest;
  bool isComplete;
  TheoryTestQuestionList questionList;
  int timeTaken;
  int timeRemaining;

  TestResultPageModel({this.isMockTest, this.isComplete, this.questionList, this.timeTaken,
    this.timeRemaining});
}