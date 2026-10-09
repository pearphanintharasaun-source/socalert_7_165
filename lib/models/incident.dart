class Incident {
  final String? id;
  final String ticketNo;
  final String attackType;
  final String investigatorEmail;
  final double cvssScore;
  final String affectedEndpoints;
  final DateTime? createdAt;

  Incident({
    this.id,
    required this.ticketNo,
    required this.attackType,
    required this.investigatorEmail,
    required this.cvssScore,
    required this.affectedEndpoints,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'ticketNo': ticketNo,
        'attackType': attackType,
        'investigatorEmail': investigatorEmail,
        'cvssScore': cvssScore,
        'affectedEndpoints': affectedEndpoints,
        'createdAt': createdAt ?? DateTime.now(),
      };

  factory Incident.fromMap(String id, Map<String, dynamic> map) => Incident(
        id: id,
        ticketNo: map['ticketNo'] ?? '',
        attackType: map['attackType'] ?? '',
        investigatorEmail: map['investigatorEmail'] ?? '',
        cvssScore: (map['cvssScore'] as num).toDouble(),
        affectedEndpoints: map['affectedEndpoints'] ?? '',
        createdAt: map['createdAt']?.toDate(),
      );
}