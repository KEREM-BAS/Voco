// ignore_for_file: hash_and_equals

import '../utils/map_util.dart';

class City {
  int id = 0;
  String? cityName;

  City.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    cityName = MapUtil.getString(json, 'cityName');
  }
}

class District {
  int id = 0;
  String? districtName;
  String? cityId;

  District.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    districtName = MapUtil.getString(json, 'districtName');
    cityId = MapUtil.getString(json, 'cityId');
  }
}

// class District {
//   int id = 0;
//   String? districtName;
//   String? cityId;

//   District({
//     this.id = 0,
//     this.districtName,
//     this.cityId,
//   });

//   District.fromJson(Map json)
//       : id = json['id'] as int,
//         districtName = json['districtName'] as String,
//         cityId = json['cityId'] as String;
// }
