// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class LessonModel {
  final String uid;
  final String teacherId;
  final String title;
  final String description;
  final String category;
  final double pricePerHour;
  final List<String> availableTimes;
  final String location;
  final DateTime createdAt;
  final bool isActive;
  LessonModel({
    required this.uid,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.category,
    required this.pricePerHour,
    required this.availableTimes,
    required this.location,
    required this.createdAt,
    required this.isActive,
  });

  LessonModel copyWith({
    String? uid,
    String? teacherId,
    String? title,
    String? description,
    String? category,
    double? pricePerHour,
    List<String>? availableTimes,
    String? location,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return LessonModel(
      uid: uid ?? this.uid,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      availableTimes: availableTimes ?? this.availableTimes,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'category': category,
      'pricePerHour': pricePerHour,
      'availableTimes': availableTimes,
      'location': location,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      uid: map['uid'] as String,
      teacherId: map['teacherId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      pricePerHour: map['pricePerHour'] as double,
      availableTimes: List<String>.from(map['availableTimes'] as List),
      location: map['location'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      isActive: map['isActive'] as bool,
    );
  }

  @override
  String toString() {
    return 'LessonModel(uid: $uid, teacherId: $teacherId, title: $title, description: $description, category: $category, pricePerHour: $pricePerHour, availableTimes: $availableTimes, location: $location, createdAt: $createdAt, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant LessonModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.teacherId == teacherId &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.pricePerHour == pricePerHour &&
        listEquals(other.availableTimes, availableTimes) &&
        other.location == location &&
        other.createdAt == createdAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        teacherId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        pricePerHour.hashCode ^
        availableTimes.hashCode ^
        location.hashCode ^
        createdAt.hashCode ^
        isActive.hashCode;
  }
}
