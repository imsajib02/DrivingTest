import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'dart:convert';


class Performance {

  int id;
  int type;
  TheoryTestQuestionList testQuestionList = TheoryTestQuestionList(list: List());


  Performance({this.id, this.type, this.testQuestionList});


  Performance.fromMap(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_PERFORMANCE_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_PERFORMANCE_COLUMNS[0]];
    type =  json[DbHelper.TABLE_PERFORMANCE_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_PERFORMANCE_COLUMNS[1]];

    testQuestionList.list.clear();

    json[DbHelper.TABLE_PERFORMANCE_COLUMNS[2]] == null ? testQuestionList.list = List() :
    jsonDecode(json[DbHelper.TABLE_PERFORMANCE_COLUMNS[2]]).forEach((question) => testQuestionList.list.add(TheoryQuestion.fromMap(question)));
  }


  toMap(int type) {

    return {

      DbHelper.TABLE_PERFORMANCE_COLUMNS[1] : type,
      DbHelper.TABLE_PERFORMANCE_COLUMNS[2] : testQuestionList == null ? jsonEncode(TheoryTestQuestionList(list: List()).list.map((question) => question.toMap()).toList()).toString() :
      jsonEncode(testQuestionList.list.map((question) => question.toMap()).toList()).toString(),
    };
  }
}


class PerformanceList {

  List<Performance> list;

  PerformanceList({this.list});

  PerformanceList.fromMap(List<Map> maps) {

    list = List();

    if(maps != null) {

      maps.forEach((performance) {
        list.add(Performance.fromMap(performance));
      });
    }
  }
}