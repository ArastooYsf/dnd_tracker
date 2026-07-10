import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_tracker/models/combatant.dart';
import 'package:dnd_tracker/models/action/damage_action.dart';

void main() {
  group('DamageAction Tests', () {
    late Combatant testCombatant;

    setUp(() {
      testCombatant = Combatant.create(
        name: 'Goblin',
        hp: 10,
        maxHp: 10,
        armorClass: 12,
        initiative: 5,
        type: CombatantType.monster,
      );
    });

    test('execute باید HP رو کم کنه', () {
      final action = DamageAction(
        targetCombatantId: testCombatant.id,
        amount: 4,
      );

      final result = action.execute(testCombatant);

      expect(result.hp, 6);
      expect(result.id, testCombatant.id); // immutable
    });

    test('execute نباید HP رو منفی کنه', () {
      final action = DamageAction(
        targetCombatantId: testCombatant.id,
        amount: 15,
      );

      final result = action.execute(testCombatant);

      expect(result.hp, 0);
    });

    test('execute باید اول از temporaryHp کم کنه', () {
      final combatantWithTempHp = testCombatant.copyWith(temporaryHp: 5);

      final action = DamageAction(
        targetCombatantId: combatantWithTempHp.id,
        amount: 3,
      );

      final result = action.execute(combatantWithTempHp);

      expect(result.temporaryHp, 2);
      expect(result.hp, 10); // hp دست‌نخورده باقی می‌مونه
    });

    test('execute باید بعد از اتمام temporaryHp به hp آسیب بزنه', () {
      final combatantWithTempHp = testCombatant.copyWith(temporaryHp: 3);

      final action = DamageAction(
        targetCombatantId: combatantWithTempHp.id,
        amount: 5,
      );

      final result = action.execute(combatantWithTempHp);

      expect(result.temporaryHp, 0);
      expect(result.hp, 8); // 10 - (5 - 3) = 8
    });

    test('undo باید HP رو برگردونه', () {
      final action = DamageAction(
        targetCombatantId: testCombatant.id,
        amount: 4,
      );

      final damaged = action.execute(testCombatant);
      expect(damaged.hp, 6);

      final restored = action.undo(damaged);
      expect(restored.hp, 10);
    });

    test('toJson و fromJson باید صحیح کار کنن', () {
      final action = DamageAction(
        targetCombatantId: testCombatant.id,
        amount: 3,
        note: 'Fire damage',
      );

      final json = action.toJson();
      final deserialized = DamageAction.fromJson(json);

      expect(deserialized.id, action.id);
      expect(deserialized.amount, 3);
      expect(deserialized.note, 'Fire damage');
      expect(deserialized.targetCombatantId, testCombatant.id);
    });
  });
}
