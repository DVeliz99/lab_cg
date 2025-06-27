import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String? uid;
  final String? uidService;
  final String? uidUser;
  final DateTime? createdAt;
  final String? comment;
  final List<String>? paramUids;

  Result({
    this.uid,
    this.uidService,
    this.createdAt,
    this.comment,
    this.uidUser,
    this.paramUids,
  });

  factory Result.fromMap(Map<String, dynamic> map, String uid) {
    return Result(
      uid: uid,
      uidUser: map['uid_user'] ?? '',
      uidService: map['uid_service'] ?? '',
      createdAt:
          map['created_at'] != null
              ? (map['created_at'] is Timestamp
                  ? (map['created_at'] as Timestamp).toDate()
                  : DateTime.tryParse(map['created_at']))
              : null,
      comment: map['comments'] ?? '', // ✅ CAMBIO AQUÍ: ahora lee 'comments'
      paramUids: List<String>.from(map['param_uids'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Result(uid: $uid, uidService: $uidService, createdAt: $createdAt, comment: $comment)';
  }
}
