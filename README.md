# MyBiblePencil (성경 필사)

성경 말씀을 직접 필사하며 하나님의 말씀을 가까이 하는 앱입니다.

## 주요 기능

- 📖 성경 말씀 필사
- 📝 메모 및 하이라이트
- 🔍 성경 구절 검색
- 💾 필사 내용 저장 및 관리
- 📱 태블릿 최적화 UI

## 지원 기기

- **Android**: 태블릿 전용 (Android 7.0 이상)
- **iOS**: iPad 전용 (iOS 13.0 이상)

## 개발 환경 설정

### 필수 요구사항

- Node.js 18.0.0 이상
- npm 또는 yarn
- Expo CLI
- Android Studio (Android 개발용)
- Xcode (iOS 개발용)

### 설치 방법

1. 저장소 클론
```bash
git clone https://github.com/[your-username]/MyBibleMap.git
cd MyBibleMap
```

2. 의존성 설치
```bash
npm install
# 또는
yarn install
```

3. 개발 서버 실행
```bash
npx expo start
```

### 빌드 및 배포

#### Android
```bash
npx expo prebuild
npx expo run:android
```

#### iOS
```bash
npx expo prebuild
npx expo run:ios
```

## 다른 컴퓨터에서 설치 및 실행하기

다른 컴퓨터에서 프로젝트를 실행하기 위해서는 다음 단계를 따르세요:

1. 프로젝트 클론:
```bash
git clone https://github.com/KyleJeong/MyBiblePencil.git
cd MyBiblePencil
```

2. 의존성 설치:
```bash
npm install
```

3. iOS의 경우 추가로:
```bash
cd ios
pod install
cd ..
```

4. 앱 실행:
- 안드로이드: `npx expo run:android`
- iOS: `npx expo run:ios`
- 또는 개발 서버: `npx expo start`

> 참고: 다른 컴퓨터에서도 동일한 개발 환경(React Native, Expo, Android Studio 또는 Xcode)이 설치되어 있어야 합니다.

## 기술 스택

- React Native
- Expo
- TypeScript
- React Navigation
- AsyncStorage

## 라이선스

이 프로젝트는 [BSD 2-Clause License](LICENSE)를 따릅니다.

## 기여 방법

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 연락처

- 이메일: [your-email@example.com]
- GitHub: [your-github-profile]
