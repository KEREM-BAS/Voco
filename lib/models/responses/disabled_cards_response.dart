import '../../utils/map_util.dart';

class DisabledCards {
  int? id;
  String? cardsNotPassedDesc;
  int? cardsNotPassedType;
  DateTime? createDate;
  DateTime? updateDate;
  int? createBy;
  int? updateBy;

  DisabledCards({
    this.id,
    this.cardsNotPassedDesc,
    this.cardsNotPassedType,
    this.createDate,
    this.updateDate,
    this.createBy,
    this.updateBy,
  });

  DisabledCards.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    cardsNotPassedDesc = MapUtil.getString(json, 'cardsNotPassedDesc');
    cardsNotPassedType = MapUtil.getInt(json, 'cardsNotPassedType');
    createDate = MapUtil.getDateTime(json, 'createDate');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    createBy = MapUtil.getInt(json, 'createBy');
    updateBy = MapUtil.getInt(json, 'updateBy');
  }
}
