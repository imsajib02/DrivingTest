import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/theory_progress_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/performance.dart';
import 'package:ukbangladrivingtest/model/theory_question.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view/theory_test/progress_animation.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/theory_progress_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';


final List<String> _percentList = <String> ['0%', '20%', '40%', '60%', '80%', '100%'];
final List<String> _percentBanglaList = <String> ['০%', '২০%', '৪০%', '৬০%', '৮০%', '১০০%'];


class TheoryProgressMonitor extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TheoryProgressMonitorState();
  }
}

class _TheoryProgressMonitorState extends State<TheoryProgressMonitor> implements TheoryProgressInterface {

  TheoryProgressViewModel _theoryProgressViewModel;
  SettingsViewModel _settingsViewModel;
  TheoryProgressInterface _progressInterface;

  Widget _progressView;


  @override
  void initState() {

    _progressInterface = this;
    _progressView = Container();

    super.initState();
  }



  @override
  void didChangeDependencies() {

    _theoryProgressViewModel = Provider.of<TheoryProgressViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _theoryProgressViewModel.removeDisposedStatus();
      _theoryProgressViewModel.getPerformanceHistory(_progressInterface);
    });

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
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
              flex: 4,
              child: _header()
          ),

          Expanded(
            flex: 14,
            child: _mainBody(),
          ),

          Expanded(
              flex: 3,
              child: _footer()
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
      child: Text(AppLocalization.of(context).getTranslatedValue("progress"),
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
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
            child: Container(
              margin: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier, right: 7.69 * SizeConfig.widthSizeMultiplier),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: mounted ? (_theoryProgressViewModel.isPractiseMode ? Colors.green[700] : Colors.grey[600]) : Colors.grey[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(AppLocalization.of(context).getTranslatedValue("practise_mode"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _theoryProgressViewModel.onModeSelected(true, _progressInterface);
                    },
                  ),

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier, right: 7.69 * SizeConfig.widthSizeMultiplier),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: mounted ? (_theoryProgressViewModel.isPractiseMode ? Colors.grey[600] : Colors.green[700]) : Colors.grey[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(AppLocalization.of(context).getTranslatedValue("mock_test_mode"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _theoryProgressViewModel.onModeSelected(false, _progressInterface);
                    },
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 19,
            child: Container(
              color: Colors.black,
              child: Column(
                children: <Widget>[

                  Expanded(
                    flex: 17,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                            child: _labelX(),
                          ),
                        ),

                        Expanded(
                          flex: 6,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier, top: 5 * SizeConfig.heightSizeMultiplier,
                                right: 7.69 * SizeConfig.widthSizeMultiplier),
                            padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                                left: 3.07 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                            color: Colors.white,
                            child: _progressView,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(AppLocalization.of(context).getTranslatedValue("your_progress_over_time"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(AppLocalization.of(context).getTranslatedValue("score_achieved_on_last_session") + (_theoryProgressViewModel.scoreList.length > 0 ?
              (_settingsViewModel.isEnglish ? _theoryProgressViewModel.scoreList.last : _theoryProgressViewModel.scoreBanglaList.last) : ""),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  ListView _labelX() {

    return ListView.builder(
      reverse: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _percentList.length,
      itemBuilder: (BuildContext context, int index) {

        return Container(
          height: 7.5 * SizeConfig.heightSizeMultiplier,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(right: 2.05 * SizeConfig.widthSizeMultiplier),
          child: Text(_settingsViewModel.isEnglish ? _percentList[index] : _percentBanglaList[index],
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          ),
        );
      },
    );
  }


  GestureDetector _footer() {

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 4.75 * SizeConfig.heightSizeMultiplier, bottom: 4.75 * SizeConfig.heightSizeMultiplier,
            left: 30.76 * SizeConfig.widthSizeMultiplier, right: 30.76 * SizeConfig.widthSizeMultiplier),
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(AppLocalization.of(context).getTranslatedValue("reset_score"),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      onTap: () {
        Provider.of<SettingsViewModel>(context, listen: false).playSound();
        _onResetPressed();
      },
    );
  }



  void _onResetPressed() async {

    if(_theoryProgressViewModel.performanceList.list.length > 0) {

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
                      child: _resetAlert(),
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
                        child: Icon(Icons.info, color: Colors.green, size: 12.82 * SizeConfig.imageSizeMultiplier,),
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



  Column _resetAlert() {

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
              Navigator.of(context).pop();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("reset_scores"),
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
            child: Text(AppLocalization.of(context).getTranslatedValue("reset_message"),
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
                    _theoryProgressViewModel.resetScore(_progressInterface);
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
                  },
                ),
              ],
            )
        ),
      ],
    );
  }



  void _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
  }



  @override
  void dispose() {
    _theoryProgressViewModel.resetModel();
    super.dispose();
  }



  @override
  void showProgressView(PerformanceList performanceList) {

    if(mounted) {

      List<Offset> offsetList = List();

      for(int i=0; i<performanceList.list.length; i++) {

        int totalCorrect = 0;

        for(int j=0; j<performanceList.list[i].testQuestionList.list.length; j++) {

          if(performanceList.list[i].testQuestionList.list[j].isAnsweredCorrectly) {

            totalCorrect = totalCorrect + 1;
          }
        }

        double score = (100 * totalCorrect) / performanceList.list[i].testQuestionList.list.length;

        offsetList.add(Offset(7.69 * SizeConfig.widthSizeMultiplier * i, score.floorToDouble() * .375 * SizeConfig.heightSizeMultiplier));
      }

      setState(() {
        _progressView = ProgressAnimation(offsetList);
      });
    }
  }



  @override
  void resetView() {

    if(mounted) {
      setState(() {
        _progressView = Container();
      });
    }
  }
}