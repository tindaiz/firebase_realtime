# Flutter Firebase Realtime App

Demo app kết nối Firebase Realtime Database và Firebase Auth (email/password).

## Quick start
1. Tạo project trên Firebase Console, bật Authentication (Email/Password) và Realtime Database.
2. Thêm Android app/iOS app và tải file cấu hình (`google-services.json` / `GoogleService-Info.plist`).
3. Cập nhật Realtime Database Rules để yêu cầu auth (xem ví dụ trong tài liệu).
4. Chạy: `flutter pub get` -> `flutter run`

Security Rules example:
```
{
  "rules": {
    "devices": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```
