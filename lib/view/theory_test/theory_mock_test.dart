import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_answer_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/test_result_page_model.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/mock_test_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_answer_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/theory_question_explanation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';


class TheoryMockTest extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TheoryMockTestState();
  }
}


class _TheoryMockTestState extends State<TheoryMockTest> implements QuestionAnswerInterface {

  MockTestViewModel _mockTestViewModel;
  QuestionViewModel _questionViewModel;
  SettingsViewModel _settingsViewModel;

  QuestionAnswerInterface _questionAnswerInterface;

  List<List<String>> _answers = List();
  List<List<String>> _banglaAnswers = List();

  String remainingTime = "";


  @override
  void initState() {
    _questionAnswerInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _mockTestViewModel = Provider.of<MockTestViewModel>(context);
    _questionViewModel = Provider.of<QuestionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _mockTestViewModel.startTest(_questionAnswerInterface, context);

      Provider.of<QuestionViewModel>(context, listen: true).getVoiceOverStatus();
      Provider.of<QuestionViewModel>(context, listen: true).getAnsweringLanguage(context);
    });

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future(() => false);
      },
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return _body();
          },
        ),
      ),
    );
  }


  Widget _body() {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
              flex: 4,
              child: _header()
          ),

          Expanded(
            flex: 19,
            child: _mainBody(),
          ),

          Expanded(
              flex: 2,
              child: _footer()
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightSizeMultiplier),
        color: Colors.green,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                  child: Icon(Icons.timer, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.white,),
                ),

                Text(remainingTime,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),),
              ],
            ),

            SizedBox(height: .625 * SizeConfig.heightSizeMultiplier),

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Icon(Icons.arrow_back, color: Colors.green,),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _onBackPressed();
                    },
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Text(mounted ? _questionViewModel.language : "",
                        style: Theme.of(context).textTheme.subtitle2,),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _questionViewModel.alterLanguage();
                    },
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(_settingsViewModel.isEnglish ? AppLocalization.of(context).getTranslatedValue("letter_q") + _mockTestViewModel.number.toString() +
                        AppLocalization.of(context).getTranslatedValue("of") + _mockTestViewModel.questionList.list.length.toString() :
                    _mockTestViewModel.totalQuestion + AppLocalization.of(context).getTranslatedValue("of") + AppLocalization.of(context).getTranslatedValue("letter_q") +
                        _mockTestViewModel.stringNumber,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Padding(
                        padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                        child: mounted ? Image.asset(
                          _questionViewModel.isVoiceActivated ? Images.voiceOnIcon : Images.voiceOffIcon,
                          color: Colors.green,
                        ) : Container(),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _questionViewModel.setVoiceOverStatus();
                    },
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Icon(Icons.play_circle_filled, color: Colors.green,),
                    ),
                    onTap: () {
                      _mockTestViewModel.speak(true, context);
                    },
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }


  Container _mainBody() {

    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Container(
            height: 1.5 * SizeConfig.heightSizeMultiplier,
            width: double.infinity,
            color: Colors.white,
            child: LinearPercentIndicator(
              lineHeight: 1 * SizeConfig.heightSizeMultiplier,
              percent: _mockTestViewModel.number > 0 ? (_mockTestViewModel.number / _mockTestViewModel.questionList.list.length) : 0.0,
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              progressColor: Colors.green,
              linearStrokeCap: LinearStrokeCap.butt,
            ),
          ),

          Expanded(
            flex: _mockTestViewModel.number > 0 && _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].hasImage ? 4 : 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  alignment: _mockTestViewModel.number > 0 ? (_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].hasImage ?
                  Alignment.center : Alignment.bottomCenter) : Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                  child: mounted ? Text(_mockTestViewModel.number > 0 ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                  _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].question :
                  _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].questionInBangla) : "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ) : Container(),
                ),

                Visibility(
                  visible: _mockTestViewModel.number > 0 && _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].hasImage,
                  child: _mockTestViewModel.number > 0 && _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].hasImage ?
                  Container(
                    height: 18.75 * SizeConfig.heightSizeMultiplier,
                    width: 38.46 * SizeConfig.widthSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 6.25 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].image),
                          fit: BoxFit.cover
                      ),
                    ),
                  ) : Container(),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _answerList(),
            ),
          ),
        ],
      ),
    );
  }


  NotificationListener _answerList() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: _mockTestViewModel.number > 0 ? ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
              margin: EdgeInsets.only(bottom: .375 * SizeConfig.heightSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier, left: 1.28 * SizeConfig.widthSizeMultiplier),
              decoration: BoxDecoration(
                color:  _mockTestViewModel.number > 0 ? (_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0 &&
                    ((index + 1) == _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered) ? Colors.white : Colors.green) : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(_mockTestViewModel.number > 0 ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? _answers[_mockTestViewModel.number-1][index] :
              _banglaAnswers[_mockTestViewModel.number-1][index]) : "",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: _mockTestViewModel.number > 0 ?
                  (_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0 &&
                      ((index + 1) == _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered) ? Colors.black : Colors.white) : Colors.black),
                ),
              ),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              _saveOptionAnswered(index);
            },
          );
        },
      ) : Center(child: CircularProgressIndicator(),),
    );
  }


  Container _footer() {

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: Row(
        children: <Widget>[

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: _mockTestViewModel.number > 1 ? Colors.black : Colors.grey[400],
                    size: 12.82 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {

                  if(_mockTestViewModel.flagList.length > 0 && _mockTestViewModel.number == _mockTestViewModel.flagList[0] + 1) {

                    return null;
                  }
                  else {

                    if(_mockTestViewModel.number > 1) {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _mockTestViewModel.decreaseNumber(_questionAnswerInterface, context);
                    }
                    else {

                      return null;
                    }
                  }
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.flag,
                    color: _mockTestViewModel.number > 0 ? (_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].isFlagged ? Colors.red : Colors.black) : Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _mockTestViewModel.onFlagPressed();
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.favorite,
                    color: _mockTestViewModel.number > 0 ? (_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].isMarkedFavourite ? Colors.green : Colors.black) :
                    Colors.black,
                    size: 8.97 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _mockTestViewModel.onFavPressed();
                },
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: _mockTestViewModel.flagList.length > 0 ? (_mockTestViewModel.number == (_mockTestViewModel.flagList[_mockTestViewModel.flagList.length - 1] + 1) ?
                  Text(AppLocalization.of(context).getTranslatedValue("finish"), style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.green),) :
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12.82 * SizeConfig.imageSizeMultiplier,)) :
                  (_mockTestViewModel.number > 0 && _mockTestViewModel.number == _mockTestViewModel.questionList.list.length ?
                  Text(AppLocalization.of(context).getTranslatedValue("finish"), style: Theme.of(context).textTheme.headline6.copyWith(
                      color: _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0 ? Colors.green : Colors.grey[400]),) :
                  Icon(Icons.arrow_forward_ios, color: _mockTestViewModel.number > 0 && _mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0 ?
                  Colors.black : Colors.grey[400], size: 12.82 * SizeConfig.imageSizeMultiplier,)),
                ),

                onTap: () {

                  if(_mockTestViewModel.flagList.length > 0) {

                    Provider.of<SettingsViewModel>(context, listen: false).playSound();

                    if(_mockTestViewModel.number == (_mockTestViewModel.flagList[_mockTestViewModel.flagList.length - 1] + 1)) {

                      _mockTestViewModel.onFinished(_questionAnswerInterface);
                    }
                    else {

                      _mockTestViewModel.increaseNumber(_questionAnswerInterface, context);
                    }
                  }
                  else {

                    if(_mockTestViewModel.number > 0) {

                      if(_mockTestViewModel.number == _mockTestViewModel.questionList.list.length) {

                        if(_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0) {

                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _mockTestViewModel.onFinished(_questionAnswerInterface);
                        }
                        else {

                          return null;
                        }
                      }
                      else {

                        if(_mockTestViewModel.questionList.list[_mockTestViewModel.number-1].optionAnswered != 0) {

                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _mockTestViewModel.increaseNumber(_questionAnswerInterface, context);
                        }
                        else {

                          return null;
                        }
                      }
                    }
                    else {

                      return null;
                    }
                  }
                },
              )
          ),
        ],
      ),
    );
  }



  @override
  void dispose() {
    _mockTestViewModel.resetModel();
    super.dispose();
  }


  void _saveOptionAnswered(int choice) {

    _mockTestViewModel.setOptionAnswered(choice + 1);

    if(_mockTestViewModel.number < _mockTestViewModel.questionList.list.length) {

      _mockTestViewModel.increaseNumber(_questionAnswerInterface, context);
    }
  }


  @override
  void addAnswers(TheoryQuestion theoryQuestion) {

    _answers.add(<String> [theoryQuestion.option1, theoryQuestion.option2, theoryQuestion.option3, theoryQuestion.option4]);
    _banglaAnswers.add(<String> [theoryQuestion.option1InBangla, theoryQuestion.option2InBangla, theoryQuestion.option3InBangla, theoryQuestion.option4InBangla]);
  }


  @override
  void removeLastAnswer() {
  }


  @override
  void showFlaggedQuestionAlert() async {

    if(mounted) {

      return showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white,
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

            return WillPopScope(
              onWillPop: () {
                return Future(() => false);
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[

                    Positioned(
                      right: 7.69 * SizeConfig.widthSizeMultiplier,
                      top: -11.25 * SizeConfig.heightSizeMultiplier,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(Images.linesIcon),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                          top: 15 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
                      ),
                      child: _flaggedAlert(),
                    ),

                    Positioned(
                      top: 11.25 * SizeConfig.heightSizeMultiplier,
                      left: 40.25 * SizeConfig.widthSizeMultiplier,
                      right: 40.25 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 10 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier)
                        ),
                      ),
                    ),

                    Positioned(
                      top: 15.5 * SizeConfig.heightSizeMultiplier,
                      left: 39.74 * SizeConfig.widthSizeMultiplier,
                      right: 39.74 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 6.25 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 11.875 * SizeConfig.heightSizeMultiplier,
                      left: 41.02 * SizeConfig.widthSizeMultiplier,
                      right: 41.02 * SizeConfig.widthSizeMultiplier,
                      child: Container(
                        height: 7.5 * SizeConfig.heightSizeMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(Images.questionIcon, color: Colors.green,),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
  }


  Column _flaggedAlert() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              Navigator.of(context).pop();
              _mockTestViewModel.saveTestResults(_questionAnswerInterface);
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("flagged_title"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 10,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
            child: Text(AppLocalization.of(context).getTranslatedValue("flagged_questions_message"),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),

        Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("yes"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _mockTestViewModel.setFlaggedNumber();
                  },
                ),

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("no"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _mockTestViewModel.saveTestResults(_questionAnswerInterface);
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  @override
  void showTestResult() {

    TestResultPageModel resultPageModel = TestResultPageModel(isMockTest: true, questionList: _mockTestViewModel.questionList,
    isComplete: true, timeTaken: (Constants.testDuration - _mockTestViewModel.remainingTime), timeRemaining: _mockTestViewModel.remainingTime);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.TEST_RESULT_PAGE_ROUTE, arguments: resultPageModel);
  }


  void _onBackPressed() async {

    _mockTestViewModel.setBackPressStatus();

    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {

          return WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: <Widget>[

                  Positioned(
                    right: 7.69 * SizeConfig.widthSizeMultiplier,
                    top: -11.25 * SizeConfig.heightSizeMultiplier,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Image.asset(Images.linesIcon),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                        top: 15 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(width: 1.02 * SizeConfig.widthSizeMultiplier, color: Colors.black)
                    ),
                    child: _quitAlert(),
                  ),

                  Positioned(
                    top: 11.25 * SizeConfig.heightSizeMultiplier,
                    left: 40.25 * SizeConfig.widthSizeMultiplier,
                    right: 40.25 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 10 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier)
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15.5 * SizeConfig.heightSizeMultiplier,
                    left: 39.74 * SizeConfig.widthSizeMultiplier,
                    right: 39.74 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 6.25 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 11.875 * SizeConfig.heightSizeMultiplier,
                    left: 41.02 * SizeConfig.widthSizeMultiplier,
                    right: 41.02 * SizeConfig.widthSizeMultiplier,
                    child: Container(
                      height: 7.5 * SizeConfig.heightSizeMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.pause_circle_filled, color: Colors.green, size: 12.82 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Column _quitAlert() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Icon(Icons.cancel, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Colors.grey,),
            ),
            onTap: () {
              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              _mockTestViewModel.setBackPressStatus();
              Navigator.of(context).pop();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("test_paused"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 10,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
            child: Text(AppLocalization.of(context).getTranslatedValue("test_paused_message"),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),

        Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("resume"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _mockTestViewModel.setBackPressStatus();
                    Navigator.of(context).pop();
                  },
                ),

                GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("quit"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                    _quitTest();
                  },
                ),
              ],
            )
        ),
      ],
    );
  }


  void _quitTest() async {

    TestResultPageModel resultPageModel = TestResultPageModel(isMockTest: true, questionList: _mockTestViewModel.questionList,
        isComplete: false, timeTaken: (Constants.testDuration - _mockTestViewModel.remainingTime), timeRemaining: _mockTestViewModel.remainingTime);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.TEST_RESULT_PAGE_ROUTE, arguments: resultPageModel);
  }


  @override
  void showRemainingTime(int time) {

    if(mounted) {

      Duration duration = Duration(seconds: time);

      String twoDigits(int n) => n.toString().padLeft(2, "0");

      String minutes = "";
      String seconds = "";

      if(_settingsViewModel.isEnglish) {

        minutes = twoDigits(duration.inMinutes.remainder(60));
        seconds = twoDigits(duration.inSeconds.remainder(60));
      }
      else {

        minutes = _translateNumber(twoDigits(duration.inMinutes.remainder(60)));
        seconds = _translateNumber(twoDigits(duration.inSeconds.remainder(60)));
      }

      setState(() {
        remainingTime = minutes + ":" + seconds;
      });
    }
  }


  String _translateNumber(String number) {

    String inBangla = "";

    for(int i=0; i<number.length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }


  @override
  void onClose() {
  }
}