# Valcue

러닝머신 · 사이클 · 계단오르기용 **음성 안내 인터벌 유산소 운동 앱**입니다.
설정한 루틴에 맞춰 구간이 바뀔 때마다 음성으로 알려줘서, 화면을 보지 않고도 운동할 수 있습니다.

Flutter로 만들었고 iOS / Android를 지원합니다.

## 주요 기능

- 인터벌 루틴 만들기 · 편집 · 추천 루틴 (`lib/features/routines`)
- 운동 진행 화면과 음성 안내 (`lib/features/workout`)
- iOS 실시간 활동(Live Activity)과 구간 알림
- 프리미엄 구독 (RevenueCat) 및 광고 (`lib/features/membership`)
- 16개 언어 지원, 다크모드 지원
- Firebase 로그인 · 분석 · 크래시 리포트

## 시작하기

```bash
flutter pub get      # 패키지 설치
flutter run          # 앱 실행
```

## 자주 쓰는 명령어

```bash
flutter test         # 테스트 전체 실행
flutter analyze      # 코드 검사
flutter gen-l10n     # 번역 파일(.arb) 수정 후 코드 다시 생성
```

## 폴더 구조

| 경로 | 내용 |
| --- | --- |
| `lib/features/` | 화면별 기능 (루틴, 운동, 설정, 프로필, 멤버십) |
| `lib/services/` | 음성·알림·결제 등 백그라운드 기능 |
| `lib/l10n/` | 다국어 번역 파일 (`.arb` 수정 후 `flutter gen-l10n`) |
| `lib/theme/` | 라이트/다크 테마 |
| `lib/widgets/`, `lib/ui/` | 공용 UI 요소 |
| `backend/` | Firebase 설정과 Cloud Functions |
| `store_listing/` | 앱스토어용 설명 문구와 스크린샷 |
| `test/` | 테스트 코드 |

## 버전 올리기

`pubspec.yaml`의 `version` 값을 수정합니다. (예: `1.1.2+22` → 앞은 사용자에게 보이는 버전, 뒤는 빌드 번호)

## 링크

- 개인정보처리방침: https://wsng2222.github.io/Valcue/privacy-policy.html
- 이용약관: https://wsng2222.github.io/Valcue/terms-of-service.html
