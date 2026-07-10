enum CustomFieldType {
  number,
  text,
  boolean,
  longText,
}

class CustomField {
  final String key;
  final String label;
  final CustomFieldType type;
  final dynamic value;

  const CustomField({
    required this.key,
    required this.label,
    required this.type,
    required this.value,
  });

  CustomField copyWith({
    String? key,
    String? label,
    CustomFieldType? type,
    dynamic value,
  }) {
    return CustomField(
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'type': type.name,
      'value': value,
    };
  }

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      key: json['key'] as String,
      label: json['label'] as String,
      type: CustomFieldType.values.byName(json['type'] as String),
      value: json['value'],
    );
  }
}
