import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/test_result_page_model.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/test_result_view_model.dart';
import 'package:ukbangladrivingtest/widgets/review_answer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';


class TheoryTestResult extends StatefulWidget {

  final TestResultPageModel _resultModel;

  TheoryTestResult(this._resultModel);

  @override
  State<StatefulWidget> createState() {
    return _TheoryTestResultState();
  }
}

class _TheoryTestResultState extends State<TheoryTestResult> with TickerProviderStateMixin {

  TestResultViewModel _testResultViewModel;
  SettingsViewModel _settingsViewModel;

  bool _animate = false;


  @override
  void initState() {

    Timer(const Duration(milliseconds: 600), () {
      _animate = true;
    });

    super.initState();
  }


  @override
  void didChangeDependencies() {

    _testResultViewModel = Provider.of<TestResultViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _testResultViewModel.removeDisposedStatus();
      _testResultViewModel.getResultStatistics(widget._resultModel, context);
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: _body(),
      ),
    );
  }


  Widget _body() {

    return Container(
      child: Column(
        children: <Widget>[

          Expanded(
              flex: 3,
              child: _header()
          ),

          Expanded(
            flex: 13,
            child: _mainBody(),
          ),

          Visibility(
            visible: false,
            child: Expanded(
                flex: 4,
                child: _footer()
            ),
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
      color: Colors.black,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 6.25 * SizeConfig.heightSizeMultiplier),
      child: Text(AppLocalization.of(context).getTranslatedValue("test_result"),
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


  Container _mainBody() {

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[

          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      radius: 33.33 * SizeConfig.imageSizeMultiplier,
                      lineWidth: 6.41 * SizeConfig.widthSizeMultiplier,
                      animation: true,
                      animationDuration: 500,
                      percent: _testResultViewModel.successRate / 100,
                      center: Text((_settingsViewModel.isEnglish ? _testResultViewModel.successRate.floor().toString() : _testResultViewModel.stringSuccessRate) + "%",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Colors.red[800],
                      progressColor: Colors.green,
                    ),
                  ),
                ),

                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      AnimatedDefaultTextStyle(
                        child: Text(_testResultViewModel.message),
                        style: _animate ? GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.green[400], fontWeight: FontWeight.bold),
                        ) : GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.green[400], fontWeight: FontWeight.normal),
                        ),
                        curve: Curves.elasticOut,
                        duration: Duration(milliseconds: 1000),
                      ),

                      Text(_settingsViewModel.isEnglish ? AppLocalization.of(context).getTranslatedValue("you_have_answered") :
                      AppLocalization.of(context).getTranslatedValue("you_have_answered") + _testResultViewModel.totalQuestion,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),

                      Text(_settingsViewModel.isEnglish ? _testResultViewModel.correctList.length.toString() + AppLocalization.of(context).getTranslatedValue("out_of") +
                          widget._resultModel.questionList.list.length.toString() : AppLocalization.of(context).getTranslatedValue("out_of") + _testResultViewModel.correctNumber,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),

                      Text(AppLocalization.of(context).getTranslatedValue("questions_correctly"),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
              child: Column(
                children: <Widget>[

                  Visibility(
                    visible: widget._resultModel.isMockTest,
                    child: Row(
                      children: <Widget>[

                        Icon(Icons.timer, color: Colors.black, size: 5.12 * SizeConfig.imageSizeMultiplier),

                        Padding(
                          padding: EdgeInsets.only(left: 3.07 * SizeConfig.widthSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("time_taken") + (_settingsViewModel.isEnglish ? _testResultViewModel.timeTaken :
                          _testResultViewModel.timeTakenBangla),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: .375 * SizeConfig.heightSizeMultiplier),

                  Visibility(
                    visible: widget._resultModel.isMockTest,
                    child: Row(
                      children: <Widget>[

                        Icon(Icons.thumb_down, color: Colors.black, size: 5.12 * SizeConfig.imageSizeMultiplier),

                        Padding(
                          padding: EdgeInsets.only(left: 3.07 * SizeConfig.widthSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("time_remaining") + (_settingsViewModel.isEnglish ? _testResultViewModel.timeRemaining :
                          _testResultViewModel.timeRemainingBangla),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: .375 * SizeConfig.heightSizeMultiplier),

                  Row(
                    children: <Widget>[

                      Icon(Icons.thumb_up, color: Colors.black, size: 5.12 * SizeConfig.imageSizeMultiplier),

                      Padding(
                        padding: EdgeInsets.only(left: 3.07 * SizeConfig.widthSizeMultiplier),
                        child: Text(AppLocalization.of(context).getTranslatedValue("your_best_category") + (_settingsViewModel.isEnglish ? _testResultViewModel.bestCategory :
                        _testResultViewModel.bestCategoryBangla),
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: .375 * SizeConfig.heightSizeMultiplier),

                  Visibility(
                    visible: _testResultViewModel.worstCategory != "" ? true : false,
                    child: Row(
                      children: <Widget>[

                        Icon(Icons.thumb_down, color: Colors.black, size: 5.12 * SizeConfig.imageSizeMultiplier),

                        Padding(
                          padding: EdgeInsets.only(left: 3.07 * SizeConfig.widthSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("your_worst_category") + (_settingsViewModel.isEnglish ? _testResultViewModel.worstCategory :
                          _testResultViewModel.worstCategoryBangla),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[

                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 5.625 * SizeConfig.heightSizeMultiplier,
                      margin: EdgeInsets.only(left: 2.54 * SizeConfig.widthSizeMultiplier, right: 2.54 * SizeConfig.widthSizeMultiplier),
                      padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(AppLocalization.of(context).getTranslatedValue("review_answers"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _reviewAnswers();
                    },
                  ),
                ),

                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 5.625 * SizeConfig.heightSizeMultiplier,
                      margin: EdgeInsets.only(left: 2.54 * SizeConfig.widthSizeMultiplier, right: 2.54 * SizeConfig.widthSizeMultiplier),
                      padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(AppLocalization.of(context).getTranslatedValue("main_menu"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Container _footer() {

    return Container(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 1.02 * SizeConfig.widthSizeMultiplier),
              child: Stack(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(top: 3.125 * SizeConfig.heightSizeMultiplier),
                    color: Colors.green,
                    child: Column(
                      children: <Widget>[

                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(.5 * SizeConfig.heightSizeMultiplier),
                            child: Text(AppLocalization.of(context).getTranslatedValue("are_you_finding_me_helpful"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 2.54 * SizeConfig.widthSizeMultiplier, right: 2.54 * SizeConfig.widthSizeMultiplier),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("rate_me"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -0.5 * SizeConfig.heightSizeMultiplier,
                    left: 10.25 * SizeConfig.widthSizeMultiplier,
                    right: 10.25 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 8.75 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          color: Colors.green,
                      ),
                    ),
                  ),

                  Positioned(
                    top: -0.5 * SizeConfig.heightSizeMultiplier,
                    left: 10.25 * SizeConfig.widthSizeMultiplier,
                    right: 10.25 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 7.5 * SizeConfig.heightSizeMultiplier,
                      padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                      child: Image.asset(Images.starIcon),
                    ),
                  ),
                ],
              ),
            )
          ),

          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 1.02 * SizeConfig.widthSizeMultiplier, left: 1.02 * SizeConfig.widthSizeMultiplier),
                child: Stack(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 3.125 * SizeConfig.heightSizeMultiplier),
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(.5 * SizeConfig.heightSizeMultiplier),
                              child: Text(AppLocalization.of(context).getTranslatedValue("share_with_friends"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 2.54 * SizeConfig.widthSizeMultiplier, right: 2.54 * SizeConfig.widthSizeMultiplier),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(AppLocalization.of(context).getTranslatedValue("share_now"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: -0.5 * SizeConfig.heightSizeMultiplier,
                      left: 10.25 * SizeConfig.widthSizeMultiplier,
                      right: 10.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 8.75 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    Positioned(
                      top: -0.5 * SizeConfig.heightSizeMultiplier,
                      left: 10.25 * SizeConfig.widthSizeMultiplier,
                      right: 10.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 7.5 * SizeConfig.heightSizeMultiplier,
                        padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                        child: Image.asset(Images.peopleIcon),
                      ),
                    ),
                  ],
                ),
              )
          ),

          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 1.02 * SizeConfig.widthSizeMultiplier),
                child: Stack(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 3.125 * SizeConfig.heightSizeMultiplier),
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(.5 * SizeConfig.heightSizeMultiplier),
                              child: Text(AppLocalization.of(context).getTranslatedValue("do_you_have_everything"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 2.54 * SizeConfig.widthSizeMultiplier, right: 2.54 * SizeConfig.widthSizeMultiplier),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(AppLocalization.of(context).getTranslatedValue("learn_more"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: -0.5 * SizeConfig.heightSizeMultiplier,
                      left: 10.25 * SizeConfig.widthSizeMultiplier,
                      right: 10.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 8.75 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    Positioned(
                      top: -0.5 * SizeConfig.heightSizeMultiplier,
                      left: 10.25 * SizeConfig.widthSizeMultiplier,
                      right: 10.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 7.5 * SizeConfig.heightSizeMultiplier,
                        padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                        child: Image.asset(Images.checkMarkIcon),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }



  @override
  void dispose() {
    _testResultViewModel.resetModel();
    super.dispose();
  }



  void _reviewAnswers() async {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return StatefulBuilder(
              builder: (context, StateSetter setState) {

                return ReviewAnswer(widget._resultModel);
              }
          );
        }
    );
  }
}