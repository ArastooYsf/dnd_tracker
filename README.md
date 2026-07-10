# 🐉 DnD Tracker

**DnD Tracker** یک اپلیکیشن Flutter برای مدیریت نبردهای (Encounter) بازی نقش‌آفرینی *Dungeons & Dragons* است. هدف پروژه فراهم‌کردن یک ابزار ردیابی نوبت (Initiative Tracker)، مدیریت وضعیت‌های (Conditions) شخصیت‌ها، اعمال آسیب/درمان، و مدیریت کمپین‌ها و کتابخانه‌ی هیولاهاست.

> **وضعیت فعلی پروژه:** مرحله‌ی اولیه توسعه. زیرساخت مدل‌ها و مدیریت وضعیت (state management) پیاده‌سازی شده، اما رابط کاربری اصلی Initiative Tracker و صفحات کمپین/نبرد/کتابخانه هنوز در دست ساخت هستند.

---

## ✨ ویژگی‌ها

### ✅ پیاده‌سازی‌شده

- ساختار پایه‌ی اپلیکیشن Flutter با Material 3
- مدل `Combatant` و مخزن (Repository) درون‌حافظه‌ای برای آن
- مدیریت وضعیت (State Management) با **Riverpod** برای لیست combatant‌ها
- مدل `Condition` برای وضعیت‌های استاندارد D&D (blinded، charmed، poisoned، prone، stunned، unconscious و ...) به‌همراه پشتیبانی از وضعیت‌های سفارشی (`custom`)
- اکشن‌های قابل Undo برای:
  - اعمال/حذف Condition (`ConditionAction`)
  - آسیب و کسر HP با در نظر گرفتن Temporary HP (`DamageAction`)
- سریال‌سازی/دی‌سریال‌سازی JSON برای مدل‌ها و اکشن‌ها
- پشتیبانی از فیلدهای سفارشی (`CustomField`) با انواع عدد، متن، بولین و متن بلند
- ساختار اولیه‌ی تست واحد برای مدل‌ها و اکشن‌ها

### 🚧 در دست توسعه / برنامه‌ریزی‌شده

- رابط کاربری کامل Initiative Tracker (صفحه‌ی فعلی فقط یک Placeholder است)
- صفحات مدیریت کمپین (`screens/campaign`)
- صفحات مدیریت نبرد (`screens/encounter`)
- صفحات کتابخانه‌ی هیولاها (`screens/monster_library`)
- لایه‌ی سرویس (`lib/services`)
- ذخیره‌سازی پایدار با SQLite (بسته‌ها در `pubspec.yaml` تعریف شده‌اند اما هنوز پیاده‌سازی نشده)
- پیاده‌سازی `InitiativeAction` (نوع آن در `ActionType` تعریف شده اما کلاس آن هنوز وجود ندارد)
- یکپارچه‌سازی کامل اکشن‌ها با یک `ActionFactory`
- تکمیل تست‌های مربوط به `Condition` و `ConditionAction`

---

## 🛠️ پشته‌ی فناوری (Tech Stack)

| بخش | فناوری |
|---|---|
| فریم‌ورک | Flutter (Material 3) |
| مدیریت وضعیت | `flutter_riverpod` |
| شناسه‌های یکتا | `uuid` |
| ذخیره‌سازی (برنامه‌ریزی‌شده) | SQLite |
| تست | `flutter_test` |

---

## 📁 ساختار پروژه
lib/

├── models/

│ ├── combatant.dart

│ ├── condition/

│ │ └── condition.dart

│ ├── custom_field/

│ │ └── custom_field.dart

│ └── action/

│ ├── base_action.dart

│ ├── condition_action.dart

│ └── damage_action.dart

├── providers/

│ └── combatant_provider.dart

├── repositories/

│ └── combatant_repository.dart

├── screens/

│ └── home_screen.dart

└── services/ # (خالی - در دست توسعه)

`
> صفحات `screens/campaign`, `screens/encounter`, `screens/monster_library` و لایه‌ی `services` در حال حاضر پیاده‌سازی نشده‌اند و بخشی از نقشه‌راه پروژه هستند.

---

## 🧩 معرفی مدل‌های اصلی

### `Combatant`
موجودیت مرکزی نبرد است که HP، Temporary HP، فیلدهای سفارشی و لیست Condition‌های فعال را نگه می‌دارد.

### `Condition`
یک وضعیت اعمال‌شده روی combatant را نشان می‌دهد؛ شامل نوع (`ConditionType`)، مدت‌زمان اختیاری (بر حسب راند)، منبع (مثلاً نام طلسم) و یادداشت.
```dart
Condition(
  type: ConditionType.poisoned,
  duration: 3,
  source: 'Poison Dart Trap',
);
`
ConditionAction(
  targetCombatantId: combatant.id,
  condition: someCondition,
  isApply: true, // true = افزودن, false = حذف
);

### `DamageAction`

آسیب را ابتدا از Temporary HP و سپس از HP اصلی کسر می‌کند و مقدار HP را در بازه‌ی `[0, maxHp]` نگه می‌دارد. `undo()` نیز HP کاسته‌شده را برمی‌گرداند.

### `CustomField`

امکان تعریف فیلدهای دلخواه برای هر combatant با انواع `number`، `text`، `boolean` و `longText`.

---

## ⚙️ مدیریت وضعیت (Riverpod)

لیست combatant‌ها از طریق `combatantListProvider` (یک `StateNotifierProvider`) در دسترس است و با هر عملیات افزودن/به‌روزرسانی/حذف، به‌طور خودکار بازسازی می‌شود:

dart
final combatants = ref.watch(combatantListProvider);

ref.read(combatantListProvider.notifier).add(newCombatant);
ref.read(combatantListProvider.notifier).update(updatedCombatant);
ref.read(combatantListProvider.notifier).remove(combatantId);

داده‌ها در حال حاضر توسط `CombatantRepository` به‌صورت درون‌حافظه‌ای (`Map<String, Combatant>`) نگهداری می‌شوند و با بستن اپلیکیشن از بین می‌روند تا زمانی که لایه‌ی SQLite پیاده‌سازی شود.

---

## 🚀 شروع به کار

### پیش‌نیازها

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (نسخه‌ی پایدار اخیر)
* Dart SDK همراه با Flutter

### نصب و اجرا

bash
# دریافت وابستگی‌ها
flutter pub get

# اجرای اپلیکیشن
flutter run

### اجرای تست‌ها

bash
flutter test

---

## 🗺️ نقشه‌راه (Roadmap)

* [ ] پیاده‌سازی UI کامل Initiative Tracker
* [ ] پیاده‌سازی `InitiativeAction`
* [ ] ساخت `ActionFactory` برای مدیریت متمرکز اکشن‌ها
* [ ] لایه‌ی سرویس و اتصال به SQLite برای ذخیره‌سازی پایدار
* [ ] صفحات مدیریت کمپین
* [ ] صفحات مدیریت نبرد (Encounter)
* [ ] صفحات کتابخانه‌ی هیولاها
* [ ] تکمیل پوشش تست برای `Condition` و `ConditionAction`

---

## ⚠️ نکات فنی شناخته‌شده

* در برخی نسخه‌های مدل `Combatant`، فیلد `conditions` و پارامتر متناظر در `copyWith` که مورد نیاز `ConditionAction` است، ممکن است هنوز به‌طور کامل هماهنگ نشده باشد. پیش از استفاده از `ConditionAction` در محیط واقعی، از هماهنگی کامل مدل `Combatant` با این اکشن اطمینان حاصل کنید.

---

## 🤝 مشارکت

این پروژه در مراحل اولیه‌ی توسعه است. اگر قصد مشارکت دارید:

1. یک Fork از مخزن بگیرید.
2. یک شاخه‌ی جدید برای تغییرات خود بسازید.
3. تست‌های مربوطه را اضافه/اجرا کنید (`flutter test`).
4. Pull Request ارسال کنید.

---

## 📄 مجوز

این پروژه تحت مجوز [MIT](LICENSE) منتشر می‌شود (در صورت نبود فایل `LICENSE`، لطفاً یکی اضافه کنید).



---

چند نکته درباره‌ی این README:

- بخش «پیاده‌سازی‌شده» و «در دست توسعه» را دقیقاً بر اساس فایل‌های واقعی موجود در آرشیو نوشتم (نه بر اساس آنچه در `pubspec.yaml` یا `structure.txt` فقط برنامه‌ریزی شده).
- بخش «نکات فنی شناخته‌شده» را عمداً نگه داشتم چون مشکل ناهماهنگی فیلد `conditions` در `Combatant` با `ConditionAction` یک مسئله‌ی واقعی و کاربردی برای هر توسعه‌دهنده‌ی بعدی است.
- بخش مجوز (License) را به‌صورت placeholder گذاشتم چون فایل `LICENSE` در آرشیو دیده نشد — اگر مجوز خاصی مدنظر دارید بگویید تا دقیق‌ترش کنم.

آیا مایلید نسخه‌ی انگلیسی این README را هم آماده کنم، یا بخش خاصی (مثلاً اسکرین‌شات‌ها، badges، یا توضیح دقیق‌تر معماری اکشن‌ها) را گسترش دهم؟