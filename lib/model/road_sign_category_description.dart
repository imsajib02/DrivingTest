import 'package:ukbangladrivingtest/database/dbhelper.dart';


class RoadSignDescription {

  int id;
  int categoryID;
  int subCategoryID;
  String description;
  String descriptionBangla;


  RoadSignDescription({this.id, this.categoryID, this.subCategoryID, this.description, this.descriptionBangla});


  RoadSignDescription.fromCategoryDescription(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[0]];
    categoryID =  json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[1]];
    description =  json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[2]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[2]];
    descriptionBangla =  json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[3]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_CATEGORY_DESCRIPTION_COLUMNS[3]];
  }


  RoadSignDescription.fromSubCategoryDescription(Map<String, dynamic> json) {

    id =  json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[0]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[0]];
    categoryID =  json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[1]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[1]];
    subCategoryID =  json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[2]] == null ? 0 : json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[2]];
    description =  json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[3]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[3]];
    descriptionBangla =  json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[4]] == null ? "" : json[DbHelper.TABLE_ROAD_SIGN_SUB_CATEGORY_DESCRIPTION_COLUMNS[4]];
  }
}