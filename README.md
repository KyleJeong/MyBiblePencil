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

- Flutter 3.19.0
- Dart 3.3.0
- Android SDK 35
- iOS 15.0+

## 설치 및 실행

1. Flutter 개발 환경 설정
   ```bash
   flutter pub get
   ```

2. 앱 실행
   ```bash
   flutter run
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

## 연락처

프로젝트 관리자 - [@your_twitter](https://twitter.com/your_twitter)

프로젝트 링크: [https://github.com/your_username/my_bible_pencil_flutter](https://github.com/your_username/my_bible_pencil_flutter)
