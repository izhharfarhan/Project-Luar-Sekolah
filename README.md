# 📒 Daily Notes App (Flutter + Firebase)

Aplikasi pencatatan harian yang memungkinkan pengguna untuk:
- Mendaftar & login (Firebase Authentication)
- Menyimpan data pengguna & catatan ke Realtime Database
- Menampilkan, menambah, mengedit, dan menghapus catatan
- Menerima push notification manual (Firebase Cloud Messaging)
- Mengelola state menggunakan Bloc

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Clone Repository
```bash
git clone https://github.com/username/project_pbi_luarsekolah.git
cd project_pbi_luarsekolah
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase
- Buka [Firebase Console](https://console.firebase.google.com/)
- Buat project baru
- Tambahkan aplikasi Android dengan `package name` sesuai di `android/app/src/main/AndroidManifest.xml`
- Unduh `google-services.json` dan tempatkan di:  
  ```
  android/app/google-services.json
  ```
- Aktifkan layanan berikut:
  - **Authentication** → metode `Email/Password`
  - **Realtime Database** → buat struktur `users/{uid}` dan `notes/{uid}/note_id`
  - **Cloud Messaging** → untuk push notifikasi

### 4. Jalankan Aplikasi
```bash
flutter run
```

---

## 🛠️ Fitur Utama

- ✅ **Autentikasi Firebase**
  - Pengguna dapat login & registrasi
- 📄 **Catatan Harian**
  - Disimpan ke Firebase **Realtime Database**
  - Hanya pengguna terkait yang bisa melihat/mengubah catatannya
- 🔔 **Push Notification**
  - Dikirim otomatis saat catatan ditambahkan
- 🧠 **State Management**
  - Menggunakan BLoC & Cubit untuk mengelola UI dan interaksi data
- 🧍 **Profil Pengguna**
  - Nama, pekerjaan, dan nomor HP juga disimpan di Realtime DB

---

## 🗂 Struktur Folder
```
lib/
├── bloc/              # Auth, MyNote, Notification Bloc
├── models/            # Data model catatan
├── screens/           # Login, Register, Home, Detail, Profile
├── services/          # NotesService (Firebase logic)
├── repository/        # NotificationRepository (FCM)
└── main.dart          # Entry point
```

---

## 🧪 Testing
Pastikan:
- Emulator/HP terhubung internet
- Token FCM muncul di console (`debugPrint`)
- Realtime Database sudah diatur public (untuk testing):
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```