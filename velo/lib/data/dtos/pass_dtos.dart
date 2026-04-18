import '../../model/pass/pass.dart';

class PassDto {
  static const String typeKey = 'type';
  static const String startDateKey = 'startDate';
  static const String endDateKey = 'endDate';

  static Pass fromJson(String id, Map<String, dynamic> json) {
    assert(json[typeKey] is String);
    assert(json[startDateKey] is String);
    assert(json[endDateKey] is String);

    return Pass(
      id: id,
      type: PassType.values.firstWhere(
        (t) => t.name == json[typeKey],
        orElse: () => PassType.day,
      ),
      startDate: DateTime.parse(json[startDateKey]),
      endDate: DateTime.parse(json[endDateKey]),
    );
  }

  Map<String, dynamic> toJson(Pass pass) {
    return {
      typeKey: pass.type.name,
      startDateKey: pass.startDate.toIso8601String(),
      endDateKey: pass.endDate.toIso8601String(),
    };
  }
}