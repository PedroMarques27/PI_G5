import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
<<<<<<< HEAD
=======
part 'BuildingsUA.g.dart';
>>>>>>> ft/join_blocks

@HiveType(typeId: 0)
class BuildingsUA {
  @HiveField(0)
  final String brbBuildingName;

  @HiveField(1)
  final int brbBuildingId;

  @HiveField(2)
  final String realBuildingName;

  @HiveField(3)
  final double lat;

  @HiveField(4)
  final double long;

  BuildingsUA(
      {@required this.brbBuildingName,
      this.brbBuildingId,
      this.realBuildingName,
      this.lat,
      this.long});
}
