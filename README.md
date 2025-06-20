# My Bible Pencil

성경 필사 앱입니다. 성경 구절을 직접 필사하며 말씀을 묵상할 수 있습니다.

## 주요 기능

- 성경 구절 선택 및 필사
  - 구약/신약 선택
  - 성경 책 선택
  - 장 선택
  - 구절 필사
- S Pen 지원
  - 갤럭시 S Pen을 이용한 자연스러운 필사
  - 필사 중 스크롤 방지
- 다국어 지원
  - 한국어
  - 영어

## 개발 환경

### 필수 요구사항
- Flutter 3.19.0
- Dart 3.3.0
- Android SDK 35
- Android Studio Hedgehog | 2023.1.1

### 권장 개발 환경
- Windows 11+ / Ubuntu 22.04+ / macOS 15.5+
- 16GB RAM 이상
- 10GB 이상의 여유 디스크 공간

## 설치 및 실행

### 1. 개발 환경 설정

#### Flutter SDK 설치
```bash
# Flutter SDK 다운로드 및 설치
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### Android 개발 환경 설정
1. Android Studio 설치
2. Android SDK 설치 (Android Studio > SDK Manager)
3. 환경 변수 설정
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 2. 프로젝트 설정

```bash
# 프로젝트 클론
git clone https://github.com/your_username/my_bible_pencil_flutter.git
cd my_bible_pencil_flutter

# 의존성 설치
flutter pub get
```

### 3. 빌드 및 실행

#### Android 빌드
```bash
# 디버그 빌드
flutter build apk --debug

# 릴리즈 빌드
flutter build apk --release

# 특정 아키텍처 빌드
flutter build apk --target-platform android-arm64
```

#### 앱 실행
```bash
# 디버그 모드로 실행
flutter run

# 특정 디바이스에서 실행
flutter run -d <device-id>
```

## 프로젝트 구조

```
lib/
  ├── l10n/              # 다국어 지원
  ├── models/            # 데이터 모델
  ├── screens/           # 화면
  ├── services/          # API 서비스
  └── main.dart          # 앱 진입점
```

## API 연동

- Bible API를 사용하여 성경 구절 데이터를 가져옵니다.
- API 키는 환경 변수로 관리됩니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## Important Note: App Icon Generation

- The app icon is generated from the original image file: `assets/images/logo.jpg`.
- **Do NOT commit the generated icon files** (e.g., `android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets/AppIcon.appiconset/`) to git. Only the original image should be tracked.
- If you clone this project or set up a new development environment, you must generate the app icons by running:

```sh
flutter pub run flutter_launcher_icons:main
```

- Make sure to run this command whenever you change the app icon image as well.
