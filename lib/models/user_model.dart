// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String userType; // "teacher" ya da "student"
  final bool isAuthenticated;
  final String? profilePic;
  final String? bio;
  final int balance;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.userType,
    required this.isAuthenticated,
    this.profilePic,
    this.bio,
    required this.balance,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? userType,
    bool? isAuthenticated,
    String? profilePic,
    String? bio,
    int? balance,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'userType': userType,
      'isAuthenticated': isAuthenticated,
      'profilePic': profilePic,
      'bio': bio,
      'balance': balance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      userType: map['userType'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      balance: map['balance'] as int,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, userType: $userType, isAuthenticated: $isAuthenticated, profilePic: $profilePic, bio: $bio, balance: $balance)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.userType == userType &&
        other.isAuthenticated == isAuthenticated &&
        other.profilePic == profilePic &&
        other.bio == bio &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        userType.hashCode ^
        isAuthenticated.hashCode ^
        profilePic.hashCode ^
        bio.hashCode ^
        balance.hashCode;
  }
}
