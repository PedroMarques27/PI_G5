import 'package:flutter/foundation.dart';

class BuildingsUA {
  BuildingsUA(
      {@required this.brbBuildingName,
      this.brbBuildingId,
      this.realBuildingName,
      this.lat,
      this.long});

  final String brbBuildingName;

  final int brbBuildingId;

  final String realBuildingName;

  final double lat;

  final double long;
}
