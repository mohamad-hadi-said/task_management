<div align="center">

# ⏱️ وقتي أمانة | Waqti Amana
### تطبيق إدارة المهام والإنتاجية الذكي للأجهزة الذكية بنظام Flutter
**A Modern, Offline-First Task Management & Productivity Flutter Application**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)](https://bloclibrary.dev)
[![SQLite](https://img.shields.io/badge/Database-SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org)
[![Version](https://img.shields.io/badge/Version-1.1.0-brightgreen?style=for-the-badge)](https://github.com)

<br/>

</div>

---

## 📖 نبذة عن التطبيق | Overview

**"وقتي أمانة"** هو تطبيق إنتاجية وإدارة مهام حديث ومبني بالكامل باستخدام إطار العمل **Flutter**، مصمم خصيصاً لتوفير تجربة مستخدم عربية أصيلة ومرنة (RTL). يتيح التطبيق تنظيم وإدارة المهام اليومية والمهام الفرعية بسهولة تامة، مع دعم العمل بدون إنترنت (Offline-First) ونظام تنبيهات تفاعلي مجدول يساعدك على استثمار وقتك وإنجاز أهدافك بكفاءة عالية.

---

## ✨ المميزات الرئيسية | Key Features

### 📋 إدارة متكاملة للمهام (Comprehensive Task Management)
- **إضافة وتعديل وحذف المهام**: إضافة مهام جديدة مع عنوان وتفاصيل وملاحظات وموعد استحقاق محدد بالوقت والتاريخ.
- **عرض تفصيلي للمهمة**: صفحة خاصة لكل مهمة تعرض كافة معلوماتها والمهام الفرعية المرتبطة بها.
- **مستويات الأولوية (Priorities)**: تصنيف المهام حسب الأهمية (منخفضة 🟢 - متوسطة 🟡 - عالية 🔴).
- **حالات المهام (Task Statuses)**: تنظيم المهام وفق مراحلها:
  - ⏳ **قيد الانتظار (To Do)**
  - 🔄 **قيد التنفيذ (In Progress)**
  - ✅ **منجزة (Done)**

### 🧩 المهام الفرعية وقوائم المتابعة (Subtasks / Checklists)
- تجزئة المهام الكبيرة إلى مهام فرعية أصغر لمتابعة تقدم الإنجاز خطوة بخطوة.
- تحديث فوري لحالة المهمة الفرعية بنقرة واحدة.

### 🎯 التحديد المتعدد والحذف الجماعي (Multi-Selection & Bulk Actions)
- إمكانية الضغط المطول لتفعيل وضع التحديد المتعدد للمهام.
- حذف عدة مهام مختارة دفعة واحدة مع رسائل تأكيد لحماية البيانات.

### 🔍 بحث وفلترة ذكية (Smart Search & Tab Filtering)
- شريط بحث ديناميكي للوصول السريع للمهام بالاسم أو التفاصيل.
- شريط تبويبات علوي للتنقل السريع بين (جميع المهام، قيد الانتظار، قيد التنفيذ، المنجزة).

### 🔔 إشعارات وتنبيهات تفاعلية (Smart Notifications)
- جدولة إشعارات تذكيرية دقيقة لكل مهمة بحسب وقت وتاريخ الاستحقاق.
- إشعارات تفاعلية تحتوي على أزرار إجراء سريعة:
  - **إنجاز**: تحديد المهمة كمنجزة مباشرة من شريط الإشعارات دون الحاجة لفتح التطبيق.
  - **تجاهل**: إغلاق التنبيه وإلغاء التذكير.

### 🎨 تصميم عربي عصري وواجهات تفاعلية (Modern RTL Design)
- واجهة مستخدم عربية بالكامل متوافقة 100% مع اتجاه اليمين لليسار (RTL).
- خط **Cairo** المتميز بجميع أوزانه لقراءة مريحة وأناقة بصرية.
- دعم كامل لـ **الوضع الليلي (Dark Mode)** و**الوضع النهاري (Light Mode)** مع إمكانية التبديل من الإعدادات.
- رسائل تنبيهية وتأكيدية جذابة وتفاعلية باستخدام مكتبة `toastification`.

### 💾 تخزين محلي بدون إنترنت (Offline-First with SQLite)
- حفظ محلي دائم وسريع لجميع المهام والمهام الفرعية باستخدام قاعدة بيانات **SQLite**.
- يعمل التطبيق بكامل وظائفه دون الحاجة لأي اتصال بالإنترنت.

---

## 🛠️ البنية الهندسية والتقنيات | Architecture & Tech Stack

تم بناء المشروع باتباع أفضل الممارسات الهندسية ومعمارية البرمجيات النظيفة (Clean Architecture Principles)، وتوزيع منطق العمل بشكل يسهل صيانته واختباره.

```
lib/
├── core/                         # الأدوات والخدمات المشتركة
│   ├── cache/                    # إدارة التخزين المؤقت (SharedPreferences)
│   ├── error/ & errors/          # معالجة الأخطاء والاستثناءات
│   ├── services/                 # خدمات التنبيهات وقاعدة البيانات (SQLite Helper, Notifications)
│   ├── theme/                    # الثيمات والألوان والخطوط (AzkarTheme, AppTextTheme)
│   └── utils/                    # الدوال المساعدة، الثوابت، والتعدادات (Enums, Toast)
│
├── injection_container.dart       # حقن التبعيات (Dependency Injection via GetIt)
├── main.dart                     # نقطة انطلاق التطبيق وإعداد البيئة والتنبيهات
│
└── src/
    ├── api/                      # إدارة عمليات قاعدة البيانات وتوليد البيانات الأولية
    ├── logic/                    # منطق إدارة الحالة (BLoC / Cubits)
    │   ├── cubit/                # كيبوت البحث، اختيار المهام، والثيمات
    │   ├── tasks/                # Bloc إدارة المهام الرئيسية
    │   └── subtasks/             # Bloc إدارة المهام الفرعية
    ├── model/                    # نماذج البيانات (TaskModel, SubtaskModel) مع Freezed و JsonSerializable
    ├── repositories/             # مستودع البيانات (TaskRepository) للتعامل مع قاعدة البيانات
    └── view/                     # واجهات وتصميم التطبيق
        ├── pages/                # شاشات التطبيق (MainPage, TasksPage, AddTaskPage, EditTaskPage, DetailsTaskPage, SettingsPage)
        └── widgets/              # العناصر القابلة لإعادة الاستخدام (TaskCard, BottomNavigation, etc.)
```

### 📦 الحزم والمكتبات المستخدمة (Packages & Dependencies)

| الحزمة | الغرض |
| :--- | :--- |
| **`flutter_bloc` / `bloc`** | إدارة الحالة (State Management) المعتمدة على الأحداث |
| **`get_it`** | حقن التبعيات وإدارة الكائنات المشتركة (Dependency Injection) |
| **`sqflite` & `path`** | إدارة قاعدة البيانات المحلية SQLite للتخزين دون اتصال |
| **`awesome_notifications`** | إدارة الإشعارات المحلية المجدولة والتفاعلية |
| **`freezed` & `json_serializable`** | توليد نماذج البيانات ومعالجة التحويل من وإلى JSON |
| **`shared_preferences`** | تخزين إعدادات المستخدم والبيانات الخفيفة |
| **`toastification`** | عرض إشعارات ورسائل منبثقة بتصميم عصري |
| **`connectivity_plus`** | فحص ومراقبة حالة الاتصال بالشبكة |
| **`logger`** | تسجيل الأحداث وسجلات التطبيق أثناء التطوير |

---

## 🚀 كيفية البدء والتشغيل | Getting Started

### المتطلبات الأساسية (Prerequisites)
- تثبيت [Flutter SDK](https://flutter.dev/docs/get-started/install) (الإصدار `>= 3.8.1` أو أحدث).
- تثبيت بيئة التطوير المفضلة (VS Code أو Android Studio).
- جهاز حقيقي أو محاكي (Android Emulator / iOS Simulator / Windows).

### خطوات التثبيت والتشغيل (Installation Steps)

1. **استنساخ المستودع (Clone Repository):**
   ```bash
   git clone https://github.com/mohamad-hadi-said/task_management.git
   cd task_management
   ```

2. **تحميل التبعيات والمكتبات (Install Dependencies):**
   ```bash
   flutter pub get
   ```

3. **توليد الكود البرمجي (Build Runner - اختياري في حال تعديل الموديلز):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **تشغيل التطبيق (Run Application):**
   ```bash
   flutter run
   ```

### تشغيل الاختبارات (Running Tests)
يحتوي المشروع على اختبارات وحدة واختبارات لواجهات المستخدم للتأكد من استقرار الكود البرمجي:
```bash
flutter test
```

---

## 👨‍💻 المطور | Developer

تم تطوير هذا التطبيق بواسطة:
- **المهندس محمد هادي سعيد (Eng. Mohamad Hadi Said)**
- 💼 **LinkedIn**: [mohamad-hadi-said](https://sy.linkedin.com/in/mohamad-hadi-said)

---

## 📄 الترخيص | License

هذا المشروع متاح للاستخدام والتعلم والتطوير. جميع الحقوق محفوظة للمطور © 2026.
