class Student {
  String id;
  String name;
  String fatherName;
  String studentClass;
  String phone;
  bool feePaid;
  Map<String, bool> attendance; // Date string -> Present/Absent
  Map<String, double> testMarks; // Month string -> Marks out of 100

  Student({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.studentClass,
    required this.phone,
    required this.feePaid,
    Map<String, bool>? attendance,
    Map<String, double>? testMarks,
  }) : attendance = attendance ?? {},
       testMarks = testMarks ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fatherName': fatherName,
      'studentClass': studentClass,
      'phone': phone,
      'feePaid': feePaid,
      'attendance': attendance,
      'testMarks': testMarks,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      fatherName: json['fatherName'],
      studentClass: json['studentClass'],
      phone: json['phone'],
      feePaid: json['feePaid'],
      attendance: Map<String, bool>.from(json['attendance'] ?? {}),
      testMarks: Map<String, double>.from(json['testMarks'] ?? {}),
    );
  }
}