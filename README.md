# TaskFlow Pro - اپلیکیشن مدیریت وظایف

یک اپلیکیشن To Do List کامل و حرفه‌ای ساخته‌شده با Flutter

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

---

## 📞 پشتیبانی

برای سوال یا مشکل issue باز کنید.
