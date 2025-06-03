// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '나의 성경 필기';

  @override
  String get oldTestament => '구약';

  @override
  String get newTestament => '신약';

  @override
  String get selectBook => '성경책 선택';

  @override
  String get selectChapter => '장 선택';

  @override
  String get write => '쓰기';

  @override
  String get saved => '저장됨';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get korean => '한국어';

  @override
  String get english => '영어';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '수정';

  @override
  String get search => '검색';

  @override
  String get noResults => '검색 결과가 없습니다';

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get loading => '로딩 중...';

  @override
  String get tabletOnly => '이 앱은 태블릿에서만 실행할 수 있습니다';

  @override
  String get tabletOnlyMessage => 'iPad 또는 안드로이드 태블릿에서 실행해주세요';

  @override
  String get font => '글꼴';

  @override
  String get fontSize => '글자 크기';

  @override
  String get selectFont => '글꼴 선택';

  @override
  String get small => '작게';

  @override
  String get medium => '보통';

  @override
  String get large => '크게';

  @override
  String get extraLarge => '매우 크게';
}
