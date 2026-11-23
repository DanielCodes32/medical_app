class DoctorAvailabilityModel {
  final int? id;
  final int? doctorid;
  final String? dayofweek;
  final String? starttime;
  final String? endtime;
  final bool isregistered;

  DoctorAvailabilityModel({
    this.id,
    this.doctorid,
    this.dayofweek,
    this.starttime,
    this.endtime,
    this.isregistered = false,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      id: json['id'] as int?,
      doctorid: json['doctorid'] as int?,
      dayofweek: json['dayofweek'] as String?,
      starttime: json['starttime'] as String?,
      endtime: json['endtime'] as String?,
      isregistered: json['isregistered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorid': doctorid,
    'dayofweek': dayofweek,
    'starttime': starttime,
    'endtime': endtime,
    'isregistered': isregistered,
  };

  static String formatTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return "";
    final trimmed = timeStr.trim();
    final parts = trimmed.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].trim().padLeft(2, '0');
      final minute = parts[1].trim().padLeft(2, '0');
      return '$hour:$minute';
    }
    return trimmed;
  }

  String get formattedStartTime => formatTime(starttime);
  String get formattedEndTime => formatTime(endtime);

  String get formattedTimeRange {
    final start = formattedStartTime;
    final end = formattedEndTime;
    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }
    return start.isNotEmpty ? start : (starttime ?? '');
  }
}
