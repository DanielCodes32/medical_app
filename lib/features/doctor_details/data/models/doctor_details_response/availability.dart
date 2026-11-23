class Availability {
  final int? id;
  final int? patientid;
  final int? doctorid;
  final String? scheduledat;
  final String? status;
  final String? notes;
  final String? createdat;
  final String? firstname;
  final String? lastname;

  Availability({
    this.id,
    this.patientid,
    this.doctorid,
    this.scheduledat,
    this.status,
    this.notes,
    this.createdat,
    this.firstname,
    this.lastname,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        id: json['id'] as int?,
        patientid: json['patientid'] as int?,
        doctorid: json['doctorid'] as int?,
        scheduledat: json['scheduledat'] as String?,
        status: json['status'] as String?,
        notes: json['notes'] as String?,
        createdat: json['createdat'] as String?,
        firstname: json['firstname'] as String?,
        lastname: json['lastname'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientid': patientid,
        'doctorid': doctorid,
        'scheduledat': scheduledat,
        'status': status,
        'notes': notes,
        'createdat': createdat,
        'firstname': firstname,
        'lastname': lastname,
      };

  DateTime? get scheduledDateTime {
    if (scheduledat == null) return null;
    return DateTime.tryParse(scheduledat!);
  }

  String get formattedDate {
    final dt = scheduledDateTime;
    if (dt == null) return scheduledat ?? '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = days[dt.weekday - 1];
    final month = months[dt.month - 1];
    return '$weekday, $month ${dt.day}, ${dt.year}';
  }

  String get formattedTime {
    final dt = scheduledDateTime;
    if (dt == null) return '';
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  String patientDisplayNameWithOrder(int orderNumber) {
    final parts = [firstname, lastname].where((s) => s != null && s.isNotEmpty);
    if (parts.isNotEmpty) {
      return parts.join(' ');
    }
    return 'Patient #$orderNumber';
  }

  String get patientDisplayName {
    final parts = [firstname, lastname].where((s) => s != null && s.isNotEmpty);
    if (parts.isNotEmpty) {
      return parts.join(' ');
    }
    return 'Patient';
  }

  bool get isPending => status?.toLowerCase() == 'pending';
  bool get isConfirmed => status?.toLowerCase() == 'confirmed';
  bool get isCancelled => status?.toLowerCase() == 'cancelled';
}
