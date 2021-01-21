import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:ukbangladrivingtest/utils/size_config.dart';

class FlagPainter extends CustomPainter {

  List<Offset> _offsetList;
  List<List<Offset>> rangeList;
  double rangeWidth;

  FlagPainter(this._offsetList, {this.rangeList, this.rangeWidth});


  @override
  void paint(Canvas canvas, Size size) {

    //horizontal min = 0, max = 808

    final Paint linePainter = Paint()..color = Colors.red..strokeWidth = 4..strokeCap = StrokeCap.round;

    final Paint markPainter5 = Paint()..color = Colors.yellow[800]..strokeWidth = 4..strokeCap = StrokeCap.round;
    final Paint markPainter4 = Paint()..color = Colors.yellow[600]..strokeWidth = 4..strokeCap = StrokeCap.round;
    final Paint markPainter3 = Paint()..color = Colors.yellow[400]..strokeWidth = 4..strokeCap = StrokeCap.round;
    final Paint markPainter2 = Paint()..color = Colors.yellow[200]..strokeWidth = 4..strokeCap = StrokeCap.round;
    final Paint markPainter1 = Paint()..color = Colors.amber[50]..strokeWidth = 4..strokeCap = StrokeCap.round;
    
    if(rangeList != null) {
      
      for(int i=0; i<rangeList.length; i++) {

        for(int j=0; j<rangeList[i].length; j++) {

          switch (j) {

            case 0:
              canvas.drawRect(Rect.fromCenter(center: rangeList[i][j], width: rangeWidth, height: 6.25 * SizeConfig.heightSizeMultiplier), markPainter5);
              break;

            case 1:
              canvas.drawRect(Rect.fromCenter(center: rangeList[i][j], width: rangeWidth, height: 6.25 * SizeConfig.heightSizeMultiplier), markPainter4);
              break;

            case 2:
              canvas.drawRect(Rect.fromCenter(center: rangeList[i][j], width: rangeWidth, height: 6.25 * SizeConfig.heightSizeMultiplier), markPainter3);
              break;

            case 3:
              canvas.drawRect(Rect.fromCenter(center: rangeList[i][j], width: rangeWidth, height: 6.25 * SizeConfig.heightSizeMultiplier), markPainter2);
              break;

            case 4:
              canvas.drawRect(Rect.fromCenter(center: rangeList[i][j], width: rangeWidth, height: 6.25 * SizeConfig.heightSizeMultiplier), markPainter1);
              break;
          }
        }
      }
    }

    for(int i=0; i<_offsetList.length; i++) {

      canvas.drawRect(Rect.fromCenter(center: _offsetList[i], width: 1.28 * SizeConfig.widthSizeMultiplier, height: 6.25 * SizeConfig.heightSizeMultiplier), linePainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}