class ModelModel {
  final String valueMember;
  final String displayMember;

//<editor-fold desc="Data Methods">
  const ModelModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'ModelModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  ModelModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return ModelModel(
      valueMember: valueMember ?? this.valueMember,
      displayMember: displayMember ?? this.displayMember,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valueMember': this.valueMember,
      'displayMember': this.displayMember,
    };
  }

  factory ModelModel.fromMap(Map<String, dynamic> map) {
    return ModelModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }

//</editor-fold>
}
