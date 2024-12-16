// ignore_for_file: public_member_api_docs, sort_constructors_first

class LessonBooking {
  final String id;
  final String studentId;
  final String lessonId; // Ders ilanı ID'si
  final String teacherId; // Öğretmen ID'si
  final DateTime
      bookingTime; // Rezervasyon zamanını daha iyi yönetebilmek için DateTime kullanıyoruz
  final String status; // "pending", "confirmed", "completed", "canceled"
  final DateTime? lessonTime; // Dersin yapılacağı zaman (null olabilir)
  final String?
      lessonFeedback; // Öğrencinin dersi bitirdikten sonra vereceği geribildirim (isteğe bağlı)
  LessonBooking({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.teacherId,
    required this.bookingTime,
    required this.status,
    this.lessonTime,
    this.lessonFeedback,
  });

  LessonBooking copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    String? teacherId,
    DateTime? bookingTime,
    String? status,
    DateTime? lessonTime,
    String? lessonFeedback,
  }) {
    return LessonBooking(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      teacherId: teacherId ?? this.teacherId,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
      lessonTime: lessonTime ?? this.lessonTime,
      lessonFeedback: lessonFeedback ?? this.lessonFeedback,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'studentId': studentId,
      'lessonId': lessonId,
      'teacherId': teacherId,
      'bookingTime': bookingTime.millisecondsSinceEpoch,
      'status': status,
      'lessonTime': lessonTime?.millisecondsSinceEpoch,
      'lessonFeedback': lessonFeedback,
    };
  }

  factory LessonBooking.fromMap(Map<String, dynamic> map) {
    return LessonBooking(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      lessonId: map['lessonId'] as String,
      teacherId: map['teacherId'] as String,
      bookingTime:
          DateTime.fromMillisecondsSinceEpoch(map['bookingTime'] as int),
      status: map['status'] as String,
      lessonTime: map['lessonTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lessonTime'] as int)
          : null,
      lessonFeedback: map['lessonFeedback'] != null
          ? map['lessonFeedback'] as String
          : null,
    );
  }

  @override
  String toString() {
    return 'LessonBooking(id: $id, studentId: $studentId, lessonId: $lessonId, teacherId: $teacherId, bookingTime: $bookingTime, status: $status, lessonTime: $lessonTime, lessonFeedback: $lessonFeedback)';
  }

  @override
  bool operator ==(covariant LessonBooking other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.studentId == studentId &&
        other.lessonId == lessonId &&
        other.teacherId == teacherId &&
        other.bookingTime == bookingTime &&
        other.status == status &&
        other.lessonTime == lessonTime &&
        other.lessonFeedback == lessonFeedback;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        lessonId.hashCode ^
        teacherId.hashCode ^
        bookingTime.hashCode ^
        status.hashCode ^
        lessonTime.hashCode ^
        lessonFeedback.hashCode;
  }
}
