import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/answering_choice_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/answering_choice_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class TheoryAnsweringChoice extends StatefulWidget {

  final List<bool> _selectedCategoryList;

  TheoryAnsweringChoice(this._selectedCategoryList);

  @override
  State<StatefulWidget> createState() {
    return _TheoryAnsweringChoiceState();
  }
}

class _TheoryAnsweringChoiceState extends State<TheoryAnsweringChoice> implements AnsweringChoiceInterface {

  AnsweringChoiceViewModel _answeringChoiceViewModel;
  SettingsViewModel _settingsViewModel;

  AnsweringChoiceInterface _answeringChoiceInterface;


  @override
  void initState() {
    _answeringChoiceInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _answeringChoiceViewModel = Provider.of<AnsweringChoiceViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _answeringChoiceViewModel.removeDisposedStatus();

      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getAutoMoveStatus();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getIncorrectAlertStatus();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getUserType();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getCountry();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getNumberOfQuestion();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getQuestionType();
      Provider.of<AnsweringChoiceViewModel>(context, listen: true).getQuestionAvailability(context, widget._selectedCategoryList);
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        _answeringChoiceViewModel.checkViewIndex(_answeringChoiceInterface);
        return Future.value(false);
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
            child: IndexedStack(
              index: _answeringChoiceViewModel.index,
              children: <Widget>[

                _mainBody(),

                _questionBankView(),

                _numberOfQuestionsView(),

                _questionTypeView(),

                _infoView(),
              ],
            ),
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
              child: Icon(_answeringChoiceViewModel.topIcon, color: Colors.green, size: 12.82 * SizeConfig.imageSizeMultiplier,),
            ),
          ),
        ],
      ),
    );
  }


  Column _mainBody() {

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
              onBackPress();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("i_want_to_revise"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Visibility(
          visible: false,
          child: Flexible(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[

                  Text(AppLocalization.of(context).getTranslatedValue("question_bank"),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline5,
                    ),
                  ),

                  GestureDetector(
                    child: Container(
                      height: 4.375 * SizeConfig.heightSizeMultiplier,
                      margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Flexible(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 3.07 * SizeConfig.imageSizeMultiplier,
                                child: Padding(
                                  padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                  child: Image.asset(Images.carIcon, color: Colors.green[600]),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_answeringChoiceViewModel.countryShortForm + AppLocalization.of(context).getTranslatedValue("in") + _answeringChoiceViewModel.userType,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(AppLocalization.of(context).getTranslatedValue("change"),
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _answeringChoiceViewModel.setIndex(AnsweringChoiceViewModel.questionBankViewIndex);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        Flexible(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                Text(AppLocalization.of(context).getTranslatedValue("number_of_questions"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline5,
                  ),
                ),

                GestureDetector(
                  child: Container(
                    height: 4.375 * SizeConfig.heightSizeMultiplier,
                    margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 3.07 * SizeConfig.imageSizeMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                child: Image.asset(Images.questionIcon, color: Colors.green[600],),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_settingsViewModel.isEnglish ? _answeringChoiceViewModel.numberOfQuestion : _answeringChoiceViewModel.numberOfQuestionBangla,
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(AppLocalization.of(context).getTranslatedValue("change"),
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _answeringChoiceViewModel.setIndex(AnsweringChoiceViewModel.numberOfQuestionViewIndex);
                  },
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 1 * SizeConfig.heightSizeMultiplier),
            child: Column(
              children: <Widget>[

                Text(AppLocalization.of(context).getTranslatedValue("question_type"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline5,
                  ),
                ),

                GestureDetector(
                  child: Container(
                    height: 4.375 * SizeConfig.heightSizeMultiplier,
                    margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 3.07 * SizeConfig.imageSizeMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(.25 * SizeConfig.heightSizeMultiplier,),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[

                                    Image.asset(Images.messageIcon, color: Colors.green[600],),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: .625 * SizeConfig.heightSizeMultiplier,),
                                      child: Text(AppLocalization.of(context).getTranslatedValue("letter_q"),
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.green[600], fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_settingsViewModel.isEnglish ? _answeringChoiceViewModel.questionType : _answeringChoiceViewModel.questionTypeBangla,
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(AppLocalization.of(context).getTranslatedValue("change"),
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _answeringChoiceViewModel.setIndex(AnsweringChoiceViewModel.questionTypeViewIndex);
                  },
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Row(
                children: <Widget>[

                  Flexible(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier),
                      child: Text(AppLocalization.of(context).getTranslatedValue("auto_move_to_next"),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Switch(
                        value: _answeringChoiceViewModel.autoMoveToNext,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _answeringChoiceViewModel.setAutoMoveStatus(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[

                  Flexible(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier),
                      child: Text(AppLocalization.of(context).getTranslatedValue("alert_if_ans_is_incorrect"),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Switch(
                        value: _answeringChoiceViewModel.isIncorrectAlertActive,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _answeringChoiceViewModel.setIncorrectAlertStatus(value);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                height: 6.25 * SizeConfig.heightSizeMultiplier,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("get_started"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _answeringChoiceViewModel.isChoiceChanged(AnsweringChoiceViewModel.mainViewIndex, answeringChoiceInterface: _answeringChoiceInterface);
              },
            ),
          ),
        ),
      ],
    );
  }


  Column _questionBankView() {

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
              _answeringChoiceViewModel.onClosed(AnsweringChoiceViewModel.questionBankViewIndex);
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 6.25 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("question_bank"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 8,
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[

                Container(
                  child: Text(AppLocalization.of(context).getTranslatedValue("learning_to_become"),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),

                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: ListView.builder(
                    itemCount: Constants.userTypeList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {

                      return Padding(
                        padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _answeringChoiceViewModel.userTypeSelection[index] ? Colors.green : Colors.white,
                                        border: Border.all(color: Colors.green, width: .256 * SizeConfig.widthSizeMultiplier)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                      child: Icon(
                                        Icons.check,
                                        size: 3.5 * SizeConfig.imageSizeMultiplier,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                    _answeringChoiceViewModel.setUserTypeSelection(index);
                                  },
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier),
                                child: Text(Constants.userTypeList[index],
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 8,
          child: Container(
            alignment: Alignment.topCenter,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: ListView.separated(
                itemCount: Constants.countryList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => Container(width: 12.82 * SizeConfig.widthSizeMultiplier),
                itemBuilder: (BuildContext context, int index) {

                  return Column(
                    children: <Widget>[

                      GestureDetector(
                        child: Container(
                          height: 6.25 * SizeConfig.heightSizeMultiplier,
                          width: 23.07 * SizeConfig.widthSizeMultiplier,
                          margin: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.28 * SizeConfig.widthSizeMultiplier,
                                  color: _answeringChoiceViewModel.countrySelection[index] ? Colors.lightGreenAccent : Colors.transparent)
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(Constants.countryFlagList[index]), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        onTap: () {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _answeringChoiceViewModel.setCountrySelection(index);
                        },
                      ),

                      Text(Constants.countryList[index],
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                height: 6.25 * SizeConfig.heightSizeMultiplier,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _answeringChoiceViewModel.isChoiceChanged(AnsweringChoiceViewModel.questionBankViewIndex);
              },
            ),
          ),
        ),
      ],
    );
  }


  Column _numberOfQuestionsView() {

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
              _answeringChoiceViewModel.onClosed(AnsweringChoiceViewModel.numberOfQuestionViewIndex);
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("number_of_questions"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 16,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: ListView.builder(
                    itemCount: Constants.numberOfQuestionsList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {

                      return Padding(
                        padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _answeringChoiceViewModel.numberOfQuestionSelection[index] ? Colors.green : Colors.white,
                                        border: Border.all(color: Colors.green, width: .256 * SizeConfig.widthSizeMultiplier)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                      child: Icon(
                                        Icons.check,
                                        size: 6 * SizeConfig.imageSizeMultiplier,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                    _answeringChoiceViewModel.setNumberOfQuestionSelection(index);
                                  },
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier),
                                child: Text(_settingsViewModel.isEnglish ? Constants.numberOfQuestionsList[index] : Constants.numberOfQuestionsBanglaList[index],
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                height: 6.25 * SizeConfig.heightSizeMultiplier,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _answeringChoiceViewModel.isChoiceChanged(AnsweringChoiceViewModel.numberOfQuestionViewIndex);
              },
            ),
          ),
        ),
      ],
    );
  }


  Column _questionTypeView() {

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
              _answeringChoiceViewModel.onClosed(AnsweringChoiceViewModel.questionTypeViewIndex);
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("question_type"),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),

        Flexible(
          flex: 16,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: ListView.builder(
                    itemCount: Constants.questionTypeList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {

                      return Padding(
                        padding: EdgeInsets.all(3.75 * SizeConfig.heightSizeMultiplier),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _answeringChoiceViewModel.questionTypeSelection[index] ? Colors.green : Colors.white,
                                        border: Border.all(color: Colors.green, width: .256 * SizeConfig.widthSizeMultiplier)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                      child: Icon(
                                        Icons.check,
                                        size: 6 * SizeConfig.imageSizeMultiplier,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                    _answeringChoiceViewModel.setQuestionTypeSelection(index);
                                  },
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 7,
                              child: Container(
                                margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier),
                                child: Text(_settingsViewModel.isEnglish ? Constants.questionTypeList[index] : Constants.questionTypeBanglaList[index],
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                height: 6.25 * SizeConfig.heightSizeMultiplier,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _answeringChoiceViewModel.isChoiceChanged(AnsweringChoiceViewModel.questionTypeViewIndex);
              },
            ),
          ),
        ),
      ],
    );
  }


  Column _infoView() {

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
              onStartPress();
            },
          ),
        ),

        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
          child: Text(_answeringChoiceViewModel.topTitle,
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
            child: Text(_answeringChoiceViewModel.infoMessage,
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
                  child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  onStartPress();
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
                  child: Text(AppLocalization.of(context).getTranslatedValue("do_not_show_again"),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _answeringChoiceViewModel.onDoNotShowPressed(_answeringChoiceInterface);
                },
              ),
            ],
          )
        ),
      ],
    );
  }


  @override
  void dispose() {
    super.dispose();
    _answeringChoiceViewModel.resetModel();
  }


  @override
  void onBackPress() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.QUESTION_CATEGORY_SELECTION_PAGE_ROUTE);
  }

  @override
  void onStartPress() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.QUESTION_VIEW_PAGE_ROUTE, arguments: widget._selectedCategoryList);
  }
}