import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_tracker/models/custom_field/custom_field.dart';

void main() {
  group('CustomField', () {
    test('creates a CustomField and reads its values', () {
      const field = CustomField(
        key: 'legendary_resistance',
        label: 'Legendary Resistance',
        type: CustomFieldType.number,
        value: 3,
      );

      expect(field.key, 'legendary_resistance');
      expect(field.label, 'Legendary Resistance');
      expect(field.type, CustomFieldType.number);
      expect(field.value, 3);
    });

    test('copyWith creates a new instance with updated value', () {
      const field = CustomField(
        key: 'is_hidden',
        label: 'Is Hidden',
        type: CustomFieldType.boolean,
        value: false,
      );

      final updated = field.copyWith(value: true);

      // مقدار جدید درست باشه
      expect(updated.value, true);
      // ولی نمونه‌ی اصلی نباید تغییر کرده باشه (immutability)
      expect(field.value, false);
    });

    test('toJson / fromJson round trip works correctly', () {
      const field = CustomField(
        key: 'notes',
        label: 'DM Notes',
        type: CustomFieldType.longText,
        value: 'This monster is secretly a dragon.',
      );

      final json = field.toJson();
      final restored = CustomField.fromJson(json);

      expect(restored.key, field.key);
      expect(restored.label, field.label);
      expect(restored.type, field.type);
      expect(restored.value, field.value);
    });
  });
}
