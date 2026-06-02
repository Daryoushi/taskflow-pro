# TaskFlow Pro - اپلیکیشن مدیریت وظایف

یک اپلیکیشن To Do List کامل و حرفه‌ای برای بازار کافه بازار، ساخته‌شده با Flutter

---

## 🆔 Application ID (یکتا برای کافه بازار)

```
ir.taskflowpro.app
```

این ID کاملاً یکتا و استاندارد ایرانی است (پسوند `ir.` برای ایران)

---

## ✨ قابلیت‌ها

- ✅ **افزودن/ویرایش/حذف وظایف** با swipe gesture
- 🎯 **اولویت‌بندی** (بالا / متوسط / پایین)
- 🗂 **دسته‌بندی** (شخصی، کاری، خرید، سلامت، آموزش، سایر)
- 📅 **سررسید** و نمایش وظایف معوق
- 🔔 **یادآوری** (با تاریخ و ساعت)
- 🔍 **جستجو** در عنوان و توضیحات
- 🔽 **مرتب‌سازی** (تاریخ، سررسید، اولویت، الفبا)
- 📊 **آمار پیشرفت** با progress bar
- 🌐 **پشتیبانی کامل از RTL** و فارسی
- 💾 **ذخیره‌سازی محلی** با SQLite
- 🗑 **حذف گروهی** وظایف تکمیل‌شده

---

## 📁 ساختار پروژه

```
lib/
├── main.dart                    # نقطه ورود اپ
├── models/
│   └── task_model.dart          # مدل داده وظیفه
├── providers/
│   └── task_provider.dart       # مدیریت State با Provider
├── services/
│   └── database_service.dart    # عملیات SQLite
├── screens/
│   ├── home_screen.dart         # صفحه اصلی
│   └── add_edit_task_screen.dart # صفحه افزودن/ویرایش
├── widgets/
│   ├── task_card.dart           # کارت وظیفه
│   ├── stats_card.dart          # کارت آمار
│   └── filter_chips.dart        # فیلترها
└── theme/
    └── app_theme.dart           # طراحی و رنگ‌ها
```

---

## 🚀 راه‌اندازی پروژه

### پیش‌نیازها
- Flutter SDK 3.16+
- Android Studio / VS Code
- JDK 17+

### نصب

```bash
# کلون پروژه
git clone <your-repo>
cd todo_app

# دانلود فونت Vazirmatn
# از https://github.com/rastikerdar/vazirmatn/releases
# فایل‌های زیر را در assets/fonts/ قرار دهید:
# - Vazirmatn-Regular.ttf
# - Vazirmatn-Medium.ttf
# - Vazirmatn-Bold.ttf

# نصب dependencies
flutter pub get

# اجرا
flutter run
```

---

## 📦 آماده‌سازی برای کافه بازار

### ۱. ساخت Keystore (یکبار انجام دهید)
```bash
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias taskflow_key
```

### ۲. تنظیم Signing در android/app/build.gradle
```groovy
android {
    signingConfigs {
        release {
            storeFile file('/path/to/my-release-key.jks')
            storePassword 'YOUR_STORE_PASSWORD'
            keyAlias 'taskflow_key'
            keyPassword 'YOUR_KEY_PASSWORD'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### ۳. ساخت APK نهایی
```bash
# APK
flutter build apk --release

# یا AAB (توصیه‌شده برای بازار)
flutter build appbundle --release
```

### ۴. مسیر خروجی
```
build/app/outputs/flutter-apk/app-release.apk
# یا
build/app/outputs/bundle/release/app-release.aab
```

---

## 🔧 تنظیمات کافه بازار

| فیلد | مقدار |
|------|-------|
| **Application ID** | `ir.taskflowpro.app` |
| **Package Name** | `ir.taskflowpro.app` |
| **Min SDK** | 21 (Android 5.0) |
| **Target SDK** | 34 (Android 14) |
| **Version Code** | 1 |
| **Version Name** | 1.0.0 |

---

## ⚠️ نکات مهم

1. **Application ID یکتا**: قبل از آپلود در کافه بازار سرچ کنید `ir.taskflowpro.app` وجود نداشته باشد
2. **فونت Vazirmatn**: حتماً فایل‌های فونت را اضافه کنید
3. **Keystore**: فایل keystore را هرگز در git قرار ندهید
4. **flutter_localizations**: اطمینان حاصل کنید که package نصب شده باشد

---

## 📞 پشتیبانی

برای سوال یا مشکل issue باز کنید.
