import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/onboarding_emphasis_text.dart';
import '../l10n/supported_app_language.dart';

/// Onboarding-local strings for all supported app languages.
///
/// This avoids relying on gen-l10n for onboarding while still being fully
/// translatable and runtime-locale aware. Falls back to English.
class OnboardingStrings {
  final String code;

  const OnboardingStrings._(this.code);

  static OnboardingStrings of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return OnboardingStrings._(
      SupportedAppLanguage.supports(code) ? code : 'en',
    );
  }

  // ---- CTA ----
  String ctaStart() => _t({
        'ko': '시작해볼까요',
        'en': "Let's start",
        'es': 'Empecemos',
        'fr': "C’est parti",
        'de': 'Los geht’s',
        'it': 'Iniziamo',
        'nl': 'Laten we beginnen',
        'da': 'Lad os starte',
        'nb': 'La oss starte',
        'ru': 'Начнём',
        'pt': 'Vamos começar',
        'ja': 'はじめましょう',
        'zh': '开始吧',
        'vi': 'Bắt đầu thôi',
        'ar': 'لنبدأ',
        'th': 'เริ่มกันเลย',
      });

  String ctaNext() => _t({
        'ko': '다음',
        'en': 'Next',
        'es': 'Siguiente',
        'fr': 'Suivant',
        'de': 'Weiter',
        'it': 'Avanti',
        'nl': 'Volgende',
        'da': 'Næste',
        'nb': 'Neste',
        'ru': 'Далее',
        'pt': 'Próximo',
        'ja': '次へ',
        'zh': '下一步',
        'vi': 'Tiếp theo',
        'ar': 'التالي',
        'th': 'ถัดไป',
      });

  String ctaFinish() => _t({
        'ko': '지금 시작하기',
        'en': 'Start now',
        'es': 'Empezar ahora',
        'fr': 'Commencer',
        'de': 'Jetzt starten',
        'it': 'Inizia ora',
        'nl': 'Nu starten',
        'da': 'Start nu',
        'nb': 'Start nå',
        'ru': 'Начать',
        'pt': 'Começar agora',
        'ja': '今すぐ始める',
        'zh': '立即开始',
        'vi': 'Bắt đầu ngay',
        'ar': 'ابدأ الآن',
        'th': 'เริ่มเลย',
      });

  // ---- Screen 1 ----
  String s1Title() => _t({
        'ko': '체계적인 인터벌\n실내 유산소 코치',
        'en': 'Systematic Interval\nIndoor Cardio Coach',
        'es': 'Entrenamiento por Intervalos\nTu Coach de Cardio en Interiores',
        'fr':
            'Entraînement par Intervalles\nVotre Coach de Cardio en Intérieur',
        'de': 'Systematisches Intervalltraining\nDein Indoor-Cardio-Coach',
        'it': 'Allenamento a Intervalli\nIl Tuo Coach di Cardio Indoor',
        'nl': 'Systematische Intervaltraining\nJouw Indoor Cardio Coach',
        'da': 'Systematisk Intervaltræning\nDin Indoor Cardio-Coach',
        'nb': 'Systematisk Intervalltrening\nDin Innendørs Cardio-Coach',
        'ru': 'Системные Интервалы\nТвой Тренер по Кардио в Помещении',
        'pt': 'Treino Intervalado Sistemático\nSeu Coach de Cardio Indoor',
        'ja': '体系的なインターバル\n室内有酸素コーチ',
        'zh': '系统化间歇训练\n你的室内有氧教练',
        'vi':
            'Tập Luyện Ngắt Quãng Có Hệ Thống\nHuấn Luyện Viên Cardio Trong Nhà',
        'ar': 'تدريب متقطع منهجي\nمدربك للكارديو الداخلي',
        'th': 'อินเทอร์วัลอย่างเป็นระบบ\nโค้ชคาร์ดิโอในร่มของคุณ',
      });

  String s1Subtitle() => _t({
        'ko': '걷기, 달리기, 자전거까지\n과학적인 인터벌로 안내해드려요',
        'en':
            'Walking, running, or cycling —\nguided by science-based intervals.',
        'es':
            'Caminar, correr o pedalear,\nguiado por intervalos con base científica.',
        'fr':
            'Marche, course ou vélo,\nguidé par des intervalles scientifiques.',
        'de':
            'Gehen, Laufen oder Radfahren –\ngeführt durch wissenschaftliche Intervalle.',
        'it': 'Camminata, corsa o bici,\nguidati da intervalli scientifici.',
        'nl':
            'Wandelen, rennen of fietsen,\ngeleid door wetenschappelijke intervallen.',
        'da': 'Gang, løb eller cykling,\nstyret af videnskabelige intervaller.',
        'nb':
            'Gange, løping eller sykling,\nstyrt av vitenskapelige intervaller.',
        'ru':
            'Ходьба, бег или велотренажёр —\nпод руководством научных интервалов.',
        'pt': 'Caminhada, corrida ou bike,\nguiado por intervalos científicos.',
        'ja': 'ウォーキングからランニング、バイクまで\n科学的なインターバルでガイドします',
        'zh': '步行、跑步还是骑行，\n用科学的间歇为你导航',
        'vi':
            'Đi bộ, chạy bộ hay đạp xe,\nđược dẫn dắt bởi các khoảng nghỉ khoa học.',
        'ar': 'المشي أو الجري أو الدراجة،\nموجّه بفترات علمية.',
        'th': 'เดิน วิ่ง หรือปั่นจักรยาน\nนำทางด้วยอินเทอร์วัลเชิงวิทยาศาสตร์',
      });

  // ---- Screen 2 ----
  List<EmphasisTextSpan> s2TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('걷기와 달리기를\n'),
          EmphasisTextSpan('원하는 대로 ', isRed: true),
          EmphasisTextSpan('조합하세요'),
        ],
        'en': const [
          EmphasisTextSpan('Combine walking and running\n'),
          EmphasisTextSpan('your way', isRed: true),
        ],
        'es': const [
          EmphasisTextSpan('Camina, corre...\n'),
          EmphasisTextSpan('Planifica tu rutina de intervalos '),
          EmphasisTextSpan('¡a tu manera!', isRed: true),
        ],
        'fr': const [
          EmphasisTextSpan('Marchez, courez…\n'),
          EmphasisTextSpan('Planifiez votre entraînement '),
          EmphasisTextSpan('à votre façon !', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('Gehen, laufen...\n'),
          EmphasisTextSpan('Plane dein Intervalltraining '),
          EmphasisTextSpan('selbst!', isRed: true),
        ],
        'it': const [
          EmphasisTextSpan('Cammina, corri...\n'),
          EmphasisTextSpan('Pianifica la tua routine a intervalli '),
          EmphasisTextSpan('come vuoi!', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('Wandelen, rennen...\n'),
          EmphasisTextSpan('Plan je intervaltraining '),
          EmphasisTextSpan('zelf!', isRed: true),
        ],
        'da': const [
          EmphasisTextSpan('Gå, løb...\n'),
          EmphasisTextSpan('Planlæg din intervaltræning '),
          EmphasisTextSpan('selv!', isRed: true),
        ],
        'nb': const [
          EmphasisTextSpan('Gå, løp...\n'),
          EmphasisTextSpan('Planlegg intervalløkten '),
          EmphasisTextSpan('selv!', isRed: true),
        ],
        'ru': const [
          EmphasisTextSpan('Ходьба, бег...\n'),
          EmphasisTextSpan('Планируй интервальную тренировку '),
          EmphasisTextSpan('по-своему!', isRed: true),
        ],
        'pt': const [
          EmphasisTextSpan('Caminhe, corra...\n'),
          EmphasisTextSpan('Planeje seu treino intervalado '),
          EmphasisTextSpan('do seu jeito!', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('歩いて、走って…\n'),
          EmphasisTextSpan('インターバルを '),
          EmphasisTextSpan('自分で設計！', isRed: true),
        ],
        'zh': const [
          EmphasisTextSpan('走走、跑跑…\n'),
          EmphasisTextSpan('把间歇训练 '),
          EmphasisTextSpan('亲自规划！', isRed: true),
        ],
        'vi': const [
          EmphasisTextSpan('Đi bộ, chạy...\n'),
          EmphasisTextSpan('Tự lên kế hoạch bài tập ngắt quãng '),
          EmphasisTextSpan('theo cách của bạn!', isRed: true),
        ],
        'ar': const [
          EmphasisTextSpan('امشِ، اركض…\n'),
          EmphasisTextSpan('خطّط لتمرينك المتقطع '),
          EmphasisTextSpan('بنفسك!', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('เดิน วิ่ง…\n'),
          EmphasisTextSpan('วางแผนอินเทอร์วัล '),
          EmphasisTextSpan('ด้วยตัวเอง!', isRed: true),
        ],
      });

  // ---- NEW Screen (between welcome and plan): Interval explainer ----
  List<EmphasisTextSpan> ex2WalkTitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('30분 '),
          EmphasisTextSpan('천천히', isRed: true),
          EmphasisTextSpan(' 걷기'),
        ],
        'en': const [
          EmphasisTextSpan('Walk '),
          EmphasisTextSpan('slowly', isRed: true),
          EmphasisTextSpan(' for 30 min'),
        ],
        'es': const [
          EmphasisTextSpan('Camina '),
          EmphasisTextSpan('despacio', isRed: true),
          EmphasisTextSpan(' durante 30 min'),
        ],
        'fr': const [
          EmphasisTextSpan('30 min de marche '),
          EmphasisTextSpan('lente', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('30 Min. '),
          EmphasisTextSpan('langsam', isRed: true),
          EmphasisTextSpan(' gehen'),
        ],
        'it': const [
          EmphasisTextSpan('30 min di camminata '),
          EmphasisTextSpan('lenta', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('30 min '),
          EmphasisTextSpan('rustig', isRed: true),
          EmphasisTextSpan(' wandelen'),
        ],
        'da': const [
          EmphasisTextSpan('30 min '),
          EmphasisTextSpan('rolig', isRed: true),
          EmphasisTextSpan(' gang'),
        ],
        'nb': const [
          EmphasisTextSpan('30 min '),
          EmphasisTextSpan('rolig', isRed: true),
          EmphasisTextSpan(' gange'),
        ],
        'ru': const [
          EmphasisTextSpan('30 мин '),
          EmphasisTextSpan('медленной', isRed: true),
          EmphasisTextSpan(' ходьбы'),
        ],
        'pt': const [
          EmphasisTextSpan('30 min de caminhada '),
          EmphasisTextSpan('leve', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('30分 '),
          EmphasisTextSpan('ゆっくり', isRed: true),
          EmphasisTextSpan('歩く'),
        ],
        'zh': const [
          EmphasisTextSpan('慢走', isRed: true),
          EmphasisTextSpan('30分钟'),
        ],
        'vi': const [
          EmphasisTextSpan('Đi bộ '),
          EmphasisTextSpan('chậm', isRed: true),
          EmphasisTextSpan(' trong 30 phút'),
        ],
        'ar': const [
          EmphasisTextSpan('30 دقيقة من المشي '),
          EmphasisTextSpan('البطيء', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('เดิน'),
          EmphasisTextSpan('ช้าๆ', isRed: true),
          EmphasisTextSpan(' 30 นาที'),
        ],
      });

  List<EmphasisTextSpan> ex2RunTitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('10분 '),
          EmphasisTextSpan('빠르게', isRed: true),
          EmphasisTextSpan(' 뛰기'),
        ],
        'en': const [
          EmphasisTextSpan('Run '),
          EmphasisTextSpan('fast', isRed: true),
          EmphasisTextSpan(' for 10 min'),
        ],
        'es': const [
          EmphasisTextSpan('Corre '),
          EmphasisTextSpan('rápido', isRed: true),
          EmphasisTextSpan(' durante 10 min'),
        ],
        'fr': const [
          EmphasisTextSpan('10 min de course '),
          EmphasisTextSpan('rapide', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('10 Min. '),
          EmphasisTextSpan('schnell', isRed: true),
          EmphasisTextSpan(' laufen'),
        ],
        'it': const [
          EmphasisTextSpan('10 min di corsa '),
          EmphasisTextSpan('veloce', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('10 min '),
          EmphasisTextSpan('snel', isRed: true),
          EmphasisTextSpan(' rennen'),
        ],
        'da': const [
          EmphasisTextSpan('10 min '),
          EmphasisTextSpan('hurtigt', isRed: true),
          EmphasisTextSpan(' løb'),
        ],
        'nb': const [
          EmphasisTextSpan('10 min '),
          EmphasisTextSpan('rask', isRed: true),
          EmphasisTextSpan(' løping'),
        ],
        'ru': const [
          EmphasisTextSpan('10 мин '),
          EmphasisTextSpan('быстрого', isRed: true),
          EmphasisTextSpan(' бега'),
        ],
        'pt': const [
          EmphasisTextSpan('10 min de corrida '),
          EmphasisTextSpan('rápida', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('10分 '),
          EmphasisTextSpan('速く', isRed: true),
          EmphasisTextSpan('走る'),
        ],
        'zh': const [
          EmphasisTextSpan('快跑', isRed: true),
          EmphasisTextSpan('10分钟'),
        ],
        'vi': const [
          EmphasisTextSpan('Chạy '),
          EmphasisTextSpan('nhanh', isRed: true),
          EmphasisTextSpan(' trong 10 phút'),
        ],
        'ar': const [
          EmphasisTextSpan('10 دقائق من الجري '),
          EmphasisTextSpan('السريع', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('วิ่ง'),
          EmphasisTextSpan('เร็ว', isRed: true),
          EmphasisTextSpan(' 10 นาที'),
        ],
      });

  String ex2Question() => _t({
        'ko': '뭐가 더 살이 잘 빠질까요?',
        'en': 'Which burns fat better?',
        'es': '¿Qué quema más grasa?',
        'fr': 'Qu’est-ce qui brûle mieux les graisses ?',
        'de': 'Was verbrennt mehr Fett?',
        'it': 'Cosa fa dimagrire di più?',
        'nl': 'Wat verbrandt beter vet?',
        'da': 'Hvad forbrænder fedt bedst?',
        'nb': 'Hva forbrenner fett best?',
        'ru': 'Что лучше сжигает жир?',
        'pt': 'O que queima mais gordura?',
        'ja': 'どっちがより痩せる？',
        'zh': '哪个更减脂？',
        'vi': 'Cái nào giúp giảm mỡ tốt hơn?',
        'ar': 'أيّهما يحرق الدهون أكثر؟',
        'th': 'อะไรช่วยเผาผลาญไขมันได้ดีกว่า?',
      });

  String ex2IntensityLabel() => _t({
        'ko': '운동 강도',
        'en': 'Intensity',
        'es': 'Intensidad',
        'fr': 'Intensité',
        'de': 'Intensität',
        'it': 'Intensità',
        'nl': 'Intensiteit',
        'da': 'Intensitet',
        'nb': 'Intensitet',
        'ru': 'Интенсивность',
        'pt': 'Intensidade',
        'ja': '運動強度',
        'zh': '运动强度',
        'vi': 'Cường độ',
        'ar': 'الشدة',
        'th': 'ความเข้มข้น',
      });

  String ex2ChoosePrompt() => _t({
        'ko': '하나를 선택해 보세요',
        'en': 'Choose one',
        'es': 'Elige una opción',
        'fr': 'Choisissez une option',
        'de': 'Wähle eine Option',
        'it': 'Scegli un’opzione',
        'nl': 'Kies er één',
        'da': 'Vælg én',
        'nb': 'Velg én',
        'ru': 'Выбери вариант',
        'pt': 'Escolha uma opção',
        'ja': 'どちらかを選んでください',
        'zh': '请选择一个',
        'vi': 'Chọn một phương án',
        'ar': 'اختر واحدًا',
        'th': 'เลือกหนึ่งตัวเลือก',
      });

  String ex2ChoiceSaved() => _t({
        'ko': '선택 완료 · 다음에서 확인하세요',
        'en': 'Selected · See the answer next',
        'es': 'Elegido · Descubre la respuesta',
        'fr': 'Choix enregistré · Découvrez ensuite la réponse',
        'de': 'Ausgewählt · Die Antwort kommt gleich',
        'it': 'Scelto · Scopri ora la risposta',
        'nl': 'Gekozen · Bekijk hierna het antwoord',
        'da': 'Valgt · Se svaret på næste skærm',
        'nb': 'Valgt · Se svaret på neste skjerm',
        'ru': 'Выбрано · Ответ — дальше',
        'pt': 'Selecionado · Veja a resposta a seguir',
        'ja': '選択しました・次で答えを確認',
        'zh': '已选择 · 下一步揭晓答案',
        'vi': 'Đã chọn · Xem đáp án tiếp theo',
        'ar': 'تم الاختيار · اكتشف الإجابة تاليًا',
        'th': 'เลือกแล้ว · ดูคำตอบถัดไป',
      });

  List<String> ex2IntervalLines() => [
        _t({
          'ko': '2분 천천히 걷고,',
          'en': 'Walk slowly for 2 minutes,',
          'es': 'Camina despacio durante 2 minutos,',
          'fr': '2 minutes de marche lente,',
          'de': '2 Minuten langsam gehen,',
          'it': 'Cammina lentamente 2 minuti,',
          'nl': '2 minuten rustig wandelen,',
          'da': 'Gå roligt i 2 minutter,',
          'nb': 'Gå rolig i 2 minutter,',
          'ru': '2 минуты медленной ходьбы,',
          'pt': 'Caminhe devagar por 2 minutos,',
          'ja': '2分ゆっくり歩いて、',
          'zh': '慢走2分钟，',
          'vi': 'Đi bộ chậm 2 phút,',
          'ar': 'امشِ ببطء لمدة دقيقتين،',
          'th': 'เดินช้าๆ 2 นาที,',
        }),
        _t({
          'ko': '3분 빠르게 뛰고,',
          'en': 'run fast for 3 minutes,',
          'es': 'corre rápido durante 3 minutos,',
          'fr': '3 minutes de course rapide,',
          'de': '3 Minuten schnell laufen,',
          'it': 'corri veloce 3 minuti,',
          'nl': '3 minuten snel rennen,',
          'da': 'løb hurtigt i 3 minutter,',
          'nb': 'løp raskt i 3 minutter,',
          'ru': '3 минуты быстрого бега,',
          'pt': 'corra rápido por 3 minutos,',
          'ja': '3分速く走って、',
          'zh': '快跑3分钟，',
          'vi': 'chạy nhanh 3 phút,',
          'ar': 'اركض بسرعة لمدة 3 دقائق،',
          'th': 'วิ่งเร็ว 3 นาที,',
        }),
        _t({
          'ko': '또 다시 2분 천천히 걷고,',
          'en': 'then walk slowly for 2 minutes again,',
          'es': 'luego camina despacio otros 2 minutos,',
          'fr': 'puis encore 2 minutes de marche lente,',
          'de': 'dann wieder 2 Minuten langsam gehen,',
          'it': 'poi cammina lentamente 2 minuti di nuovo,',
          'nl': 'dan weer 2 minuten rustig wandelen,',
          'da': 'gå så roligt i 2 minutter igen,',
          'nb': 'gå så rolig i 2 minutter igjen,',
          'ru': 'затем ещё 2 минуты медленной ходьбы,',
          'pt': 'depois caminhe devagar por 2 minutos de novo,',
          'ja': 'また2分ゆっくり歩いて、',
          'zh': '再慢走2分钟，',
          'vi': 'rồi lại đi bộ chậm 2 phút,',
          'ar': 'ثم امشِ ببطء لمدة دقيقتين مرة أخرى،',
          'th': 'แล้วเดินช้าๆ 2 นาทีอีกครั้ง,',
        }),
        _t({
          'ko': '또 다시 3분 빠르게 뛰고,',
          'en': 'and run fast for 3 minutes again,',
          'es': 'y corre rápido otros 3 minutos,',
          'fr': 'et encore 3 minutes de course rapide,',
          'de': 'und wieder 3 Minuten schnell laufen,',
          'it': 'e corri veloce 3 minuti di nuovo,',
          'nl': 'en weer 3 minuten snel rennen,',
          'da': 'og løb hurtigt i 3 minutter igen,',
          'nb': 'og løp raskt i 3 minutter igjen,',
          'ru': 'и ещё 3 минуты быстрого бега,',
          'pt': 'e corra rápido por 3 minutos de novo,',
          'ja': 'また3分速く走って、',
          'zh': '再快跑3分钟，',
          'vi': 'và lại chạy nhanh 3 phút,',
          'ar': 'ثم اركض بسرعة لمدة 3 دقائق مرة أخرى،',
          'th': 'แล้ววิ่งเร็ว 3 นาทีอีกครั้ง,',
        }),
      ];

  // Returns spans for highlighting key words in each interval line.
  List<EmphasisTextSpan>? ex2IntervalHighlightSpans(int idx) {
    switch (code) {
      case 'ko':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2분 천천히 ', isRed: false),
              EmphasisTextSpan('걷고', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3분 ', isRed: false),
              EmphasisTextSpan('빠르게', isRed: true),
              EmphasisTextSpan(' 뛰고,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('또 다시 2분 천천히 ', isRed: false),
              EmphasisTextSpan('걷고', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('또 다시 3분 ', isRed: false),
              EmphasisTextSpan('빠르게', isRed: true),
              EmphasisTextSpan(' 뛰고,', isRed: false),
            ];
        }
        break;
      case 'en':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Walk ', isRed: false),
              EmphasisTextSpan('slowly', isRed: true),
              EmphasisTextSpan(' for 2 minutes,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('run ', isRed: false),
              EmphasisTextSpan('fast', isRed: true),
              EmphasisTextSpan(' for 3 minutes,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('then walk ', isRed: false),
              EmphasisTextSpan('slowly', isRed: true),
              EmphasisTextSpan(' for 2 minutes again,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('and run ', isRed: false),
              EmphasisTextSpan('fast', isRed: true),
              EmphasisTextSpan(' for 3 minutes again,', isRed: false),
            ];
        }
        break;
      case 'es':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Camina ', isRed: false),
              EmphasisTextSpan('despacio', isRed: true),
              EmphasisTextSpan(' durante 2 minutos,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('corre ', isRed: false),
              EmphasisTextSpan('rápido', isRed: true),
              EmphasisTextSpan(' durante 3 minutos,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('luego camina ', isRed: false),
              EmphasisTextSpan('despacio', isRed: true),
              EmphasisTextSpan(' otros 2 minutos,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('y corre ', isRed: false),
              EmphasisTextSpan('rápido', isRed: true),
              EmphasisTextSpan(' otros 3 minutos,', isRed: false),
            ];
        }
        break;
      case 'fr':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2 minutes de marche ', isRed: false),
              EmphasisTextSpan('lente', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3 minutes de course ', isRed: false),
              EmphasisTextSpan('rapide', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('puis encore 2 minutes de marche ',
                  isRed: false),
              EmphasisTextSpan('lente', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('et encore 3 minutes de course ', isRed: false),
              EmphasisTextSpan('rapide', isRed: true),
              EmphasisTextSpan(',', isRed: false),
            ];
        }
        break;
      case 'de':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2 Minuten ', isRed: false),
              EmphasisTextSpan('langsam', isRed: true),
              EmphasisTextSpan(' gehen,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3 Minuten ', isRed: false),
              EmphasisTextSpan('schnell', isRed: true),
              EmphasisTextSpan(' laufen,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('dann wieder 2 Minuten ', isRed: false),
              EmphasisTextSpan('langsam', isRed: true),
              EmphasisTextSpan(' gehen,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('und wieder 3 Minuten ', isRed: false),
              EmphasisTextSpan('schnell', isRed: true),
              EmphasisTextSpan(' laufen,', isRed: false),
            ];
        }
        break;
      case 'it':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Cammina ', isRed: false),
              EmphasisTextSpan('lentamente', isRed: true),
              EmphasisTextSpan(' 2 minuti,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('corri ', isRed: false),
              EmphasisTextSpan('veloce', isRed: true),
              EmphasisTextSpan(' 3 minuti,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('poi cammina ', isRed: false),
              EmphasisTextSpan('lentamente', isRed: true),
              EmphasisTextSpan(' 2 minuti di nuovo,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('e corri ', isRed: false),
              EmphasisTextSpan('veloce', isRed: true),
              EmphasisTextSpan(' 3 minuti di nuovo,', isRed: false),
            ];
        }
        break;
      case 'nl':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2 minuten ', isRed: false),
              EmphasisTextSpan('rustig', isRed: true),
              EmphasisTextSpan(' wandelen,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3 minuten ', isRed: false),
              EmphasisTextSpan('snel', isRed: true),
              EmphasisTextSpan(' rennen,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('dan weer 2 minuten ', isRed: false),
              EmphasisTextSpan('rustig', isRed: true),
              EmphasisTextSpan(' wandelen,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('en weer 3 minuten ', isRed: false),
              EmphasisTextSpan('snel', isRed: true),
              EmphasisTextSpan(' rennen,', isRed: false),
            ];
        }
        break;
      case 'da':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Gå ', isRed: false),
              EmphasisTextSpan('roligt', isRed: true),
              EmphasisTextSpan(' i 2 minutter,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('løb ', isRed: false),
              EmphasisTextSpan('hurtigt', isRed: true),
              EmphasisTextSpan(' i 3 minutter,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('gå så ', isRed: false),
              EmphasisTextSpan('roligt', isRed: true),
              EmphasisTextSpan(' i 2 minutter igen,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('og løb ', isRed: false),
              EmphasisTextSpan('hurtigt', isRed: true),
              EmphasisTextSpan(' i 3 minutter igen,', isRed: false),
            ];
        }
        break;
      case 'nb':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Gå ', isRed: false),
              EmphasisTextSpan('rolig', isRed: true),
              EmphasisTextSpan(' i 2 minutter,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('løp ', isRed: false),
              EmphasisTextSpan('raskt', isRed: true),
              EmphasisTextSpan(' i 3 minutter,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('gå så ', isRed: false),
              EmphasisTextSpan('rolig', isRed: true),
              EmphasisTextSpan(' i 2 minutter igjen,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('og løp ', isRed: false),
              EmphasisTextSpan('raskt', isRed: true),
              EmphasisTextSpan(' i 3 minutter igjen,', isRed: false),
            ];
        }
        break;
      case 'ru':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2 минуты ', isRed: false),
              EmphasisTextSpan('медленной', isRed: true),
              EmphasisTextSpan(' ходьбы,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3 минуты ', isRed: false),
              EmphasisTextSpan('быстрого', isRed: true),
              EmphasisTextSpan(' бега,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('затем ещё 2 минуты ', isRed: false),
              EmphasisTextSpan('медленной', isRed: true),
              EmphasisTextSpan(' ходьбы,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('и ещё 3 минуты ', isRed: false),
              EmphasisTextSpan('быстрого', isRed: true),
              EmphasisTextSpan(' бега,', isRed: false),
            ];
        }
        break;
      case 'pt':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Caminhe ', isRed: false),
              EmphasisTextSpan('devagar', isRed: true),
              EmphasisTextSpan(' por 2 minutos,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('corra ', isRed: false),
              EmphasisTextSpan('rápido', isRed: true),
              EmphasisTextSpan(' por 3 minutos,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('depois caminhe ', isRed: false),
              EmphasisTextSpan('devagar', isRed: true),
              EmphasisTextSpan(' por 2 minutos de novo,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('e corra ', isRed: false),
              EmphasisTextSpan('rápido', isRed: true),
              EmphasisTextSpan(' por 3 minutos de novo,', isRed: false),
            ];
        }
        break;
      case 'ja':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('2分', isRed: false),
              EmphasisTextSpan('ゆっくり', isRed: true),
              EmphasisTextSpan('歩いて、', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('3分', isRed: false),
              EmphasisTextSpan('速く', isRed: true),
              EmphasisTextSpan('走って、', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('また2分', isRed: false),
              EmphasisTextSpan('ゆっくり', isRed: true),
              EmphasisTextSpan('歩いて、', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('また3分', isRed: false),
              EmphasisTextSpan('速く', isRed: true),
              EmphasisTextSpan('走って、', isRed: false),
            ];
        }
        break;
      case 'zh':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('慢走', isRed: true),
              EmphasisTextSpan('2分钟，', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('快跑', isRed: true),
              EmphasisTextSpan('3分钟，', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('再慢走', isRed: true),
              EmphasisTextSpan('2分钟，', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('再快跑', isRed: true),
              EmphasisTextSpan('3分钟，', isRed: false),
            ];
        }
        break;
      case 'vi':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('Đi bộ ', isRed: false),
              EmphasisTextSpan('chậm', isRed: true),
              EmphasisTextSpan(' 2 phút,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('chạy ', isRed: false),
              EmphasisTextSpan('nhanh', isRed: true),
              EmphasisTextSpan(' 3 phút,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('rồi lại đi bộ ', isRed: false),
              EmphasisTextSpan('chậm', isRed: true),
              EmphasisTextSpan(' 2 phút,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('và lại chạy ', isRed: false),
              EmphasisTextSpan('nhanh', isRed: true),
              EmphasisTextSpan(' 3 phút,', isRed: false),
            ];
        }
        break;
      case 'ar':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('امشِ ', isRed: false),
              EmphasisTextSpan('ببطء', isRed: true),
              EmphasisTextSpan(' لمدة دقيقتين،', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('اركض ', isRed: false),
              EmphasisTextSpan('بسرعة', isRed: true),
              EmphasisTextSpan(' لمدة 3 دقائق،', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('ثم امشِ ', isRed: false),
              EmphasisTextSpan('ببطء', isRed: true),
              EmphasisTextSpan(' لمدة دقيقتين مرة أخرى،', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('ثم اركض ', isRed: false),
              EmphasisTextSpan('بسرعة', isRed: true),
              EmphasisTextSpan(' لمدة 3 دقائق مرة أخرى،', isRed: false),
            ];
        }
        break;
      case 'th':
        switch (idx) {
          case 0:
            return const [
              EmphasisTextSpan('เดินช้าๆ ', isRed: true),
              EmphasisTextSpan('2 นาที,', isRed: false),
            ];
          case 1:
            return const [
              EmphasisTextSpan('วิ่งเร็ว ', isRed: true),
              EmphasisTextSpan('3 นาที,', isRed: false),
            ];
          case 2:
            return const [
              EmphasisTextSpan('แล้วเดินช้าๆ ', isRed: true),
              EmphasisTextSpan('2 นาทีอีกครั้ง,', isRed: false),
            ];
          case 3:
            return const [
              EmphasisTextSpan('แล้ววิ่งเร็ว ', isRed: true),
              EmphasisTextSpan('3 นาทีอีกครั้ง,', isRed: false),
            ];
        }
        break;
    }
    return null;
  }

  List<EmphasisTextSpan> ex2FinalLine1Spans() => _spans({
        'ko': const [
          EmphasisTextSpan('이렇게 '),
          EmphasisTextSpan('30분씩', isRed: true),
          EmphasisTextSpan(','),
        ],
        'en': const [
          EmphasisTextSpan('Like this, for '),
          EmphasisTextSpan('30 minutes', isRed: true),
          EmphasisTextSpan(','),
        ],
        'es': const [
          EmphasisTextSpan('Así, por '),
          EmphasisTextSpan('30 minutos', isRed: true),
          EmphasisTextSpan(','),
        ],
        'fr': const [
          EmphasisTextSpan('Ainsi, pendant '),
          EmphasisTextSpan('30 minutes', isRed: true),
          EmphasisTextSpan(','),
        ],
        'de': const [
          EmphasisTextSpan('So, für '),
          EmphasisTextSpan('30 Minuten', isRed: true),
          EmphasisTextSpan(','),
        ],
        'it': const [
          EmphasisTextSpan('Così, per '),
          EmphasisTextSpan('30 minuti', isRed: true),
          EmphasisTextSpan(','),
        ],
        'nl': const [
          EmphasisTextSpan('Zo, '),
          EmphasisTextSpan('30 minuten', isRed: true),
          EmphasisTextSpan(','),
        ],
        'da': const [
          EmphasisTextSpan('Sådan, i '),
          EmphasisTextSpan('30 minutter', isRed: true),
          EmphasisTextSpan(','),
        ],
        'nb': const [
          EmphasisTextSpan('Slik, i '),
          EmphasisTextSpan('30 minutter', isRed: true),
          EmphasisTextSpan(','),
        ],
        'ru': const [
          EmphasisTextSpan('Вот так, '),
          EmphasisTextSpan('30 минут', isRed: true),
          EmphasisTextSpan(','),
        ],
        'pt': const [
          EmphasisTextSpan('Assim, por '),
          EmphasisTextSpan('30 minutos', isRed: true),
          EmphasisTextSpan(','),
        ],
        'ja': const [
          EmphasisTextSpan('こうして'),
          EmphasisTextSpan('30分', isRed: true),
          EmphasisTextSpan('、'),
        ],
        'zh': const [
          EmphasisTextSpan('这样每次'),
          EmphasisTextSpan('30分钟', isRed: true),
          EmphasisTextSpan('，'),
        ],
        'vi': const [
          EmphasisTextSpan('Như vậy, '),
          EmphasisTextSpan('30 phút', isRed: true),
          EmphasisTextSpan(','),
        ],
        'ar': const [
          EmphasisTextSpan('هكذا لمدة '),
          EmphasisTextSpan('30 دقيقة', isRed: true),
          EmphasisTextSpan('،'),
        ],
        'th': const [
          EmphasisTextSpan('แบบนี้ครั้งละ '),
          EmphasisTextSpan('30 นาที', isRed: true),
          EmphasisTextSpan(','),
        ],
      });

  List<EmphasisTextSpan> ex2FinalLine2Spans() => _spans({
        'ko': const [
          EmphasisTextSpan('이게 더 잘 빠집니다'),
        ],
        'en': const [
          EmphasisTextSpan('this works better.'),
        ],
        'es': const [
          EmphasisTextSpan('esto funciona mejor.'),
        ],
        'fr': const [
          EmphasisTextSpan('c’est plus efficace.'),
        ],
        'de': const [
          EmphasisTextSpan('das wirkt besser.'),
        ],
        'it': const [
          EmphasisTextSpan('funziona meglio.'),
        ],
        'nl': const [
          EmphasisTextSpan('werkt dit beter.'),
        ],
        'da': const [
          EmphasisTextSpan('virker det bedre.'),
        ],
        'nb': const [
          EmphasisTextSpan('fungerer det bedre.'),
        ],
        'ru': const [
          EmphasisTextSpan('это работает лучше.'),
        ],
        'pt': const [
          EmphasisTextSpan('funciona melhor.'),
        ],
        'ja': const [
          EmphasisTextSpan('こちらのほうが効果的です'),
        ],
        'zh': const [
          EmphasisTextSpan('这样更有效'),
        ],
        'vi': const [
          EmphasisTextSpan('sẽ hiệu quả hơn.'),
        ],
        'ar': const [
          EmphasisTextSpan('هذا أكثر فاعلية.'),
        ],
        'th': const [
          EmphasisTextSpan('จะได้ผลดีกว่า'),
        ],
      });

  String planTotalWorkoutTimeLabel() => _t({
        'ko': '총 운동 시간',
        'en': 'Total workout time',
        'es': 'Tiempo total',
        'fr': 'Temps total',
        'de': 'Gesamtzeit',
        'it': 'Tempo totale',
        'nl': 'Totale tijd',
        'da': 'Samlet tid',
        'nb': 'Total tid',
        'ru': 'Общее время',
        'pt': 'Tempo total',
        'ja': '合計時間',
        'zh': '总时长',
        'vi': 'Tổng thời gian',
        'ar': 'الوقت الإجمالي',
        'th': 'เวลารวม',
      });

  String planTotalMinutesLabel(int n) {
    final template = _t({
      'ko': '총 {n}분',
      'en': '{n} min total',
      'es': '{n} min en total',
      'fr': '{n} min au total',
      'de': 'Insgesamt {n} Min.',
      'it': '{n} min totali',
      'nl': 'Totaal {n} min',
      'da': '{n} min i alt',
      'nb': '{n} min totalt',
      'ru': 'Всего {n} мин',
      'pt': '{n} min no total',
      'ja': '合計{n}分',
      'zh': '共{n}分钟',
      'vi': 'Tổng {n} phút',
      'ar': '{n} دقيقة إجمالًا',
      'th': 'รวม {n} นาที',
    });
    return template.replaceAll('{n}', _number(n));
  }

  String planIntervalCountLabel(int n) {
    final template = _t({
      'ko': '{n}개 구간',
      'en': '{n} intervals',
      'es': '{n} intervalos',
      'fr': '{n} intervalles',
      'de': '{n} Intervalle',
      'it': '{n} intervalli',
      'nl': '{n} intervallen',
      'da': '{n} intervaller',
      'nb': '{n} intervaller',
      'ru': '{n} интервала',
      'pt': '{n} intervalos',
      'ja': '{n}区間',
      'zh': '{n}个区间',
      'vi': '{n} chặng',
      'ar': '{n} فترات',
      'th': '{n} ช่วง',
    });
    return template.replaceAll('{n}', _number(n));
  }

  String planIntervalLabel(int n) {
    final template = _t({
      'ko': '{n}구간',
      'en': 'Interval {n}',
      'es': 'Intervalo {n}',
      'fr': 'Intervalle {n}',
      'de': 'Intervall {n}',
      'it': 'Intervallo {n}',
      'nl': 'Interval {n}',
      'da': 'Interval {n}',
      'nb': 'Intervall {n}',
      'ru': 'Интервал {n}',
      'pt': 'Intervalo {n}',
      'ja': '区間{n}',
      'zh': '第{n}区间',
      'vi': 'Chặng {n}',
      'ar': 'الفترة {n}',
      'th': 'ช่วงที่ {n}',
    });
    return template.replaceAll('{n}', _number(n));
  }

  String planMinutesLabel(int n) {
    final template = _t({
      'ko': '{n}분',
      'en': '{n} min',
      'es': '{n} min',
      'fr': '{n} min',
      'de': '{n} Min.',
      'it': '{n} min',
      'nl': '{n} min',
      'da': '{n} min',
      'nb': '{n} min',
      'ru': '{n} мин',
      'pt': '{n} min',
      'ja': '{n}分',
      'zh': '{n}分钟',
      'vi': '{n} phút',
      'ar': '{n} دقائق',
      'th': '{n} นาที',
    });
    return template.replaceAll('{n}', _number(n));
  }

  String planRecoveryWalkLabel() => _t({
        'ko': '회복 걷기',
        'en': 'Recovery walk',
        'es': 'Caminata de recuperación',
        'fr': 'Marche de récupération',
        'de': 'Erholungsgehen',
        'it': 'Camminata di recupero',
        'nl': 'Herstelwandeling',
        'da': 'Restitutionsgang',
        'nb': 'Restitusjonsgange',
        'ru': 'Восстановительная ходьба',
        'pt': 'Caminhada de recuperação',
        'ja': 'リカバリーウォーク',
        'zh': '恢复步行',
        'vi': 'Đi bộ hồi phục',
        'ar': 'مشي للاستشفاء',
        'th': 'เดินฟื้นตัว',
      });

  String planFastRunLabel() => _t({
        'ko': '빠른 달리기',
        'en': 'Fast run',
        'es': 'Carrera rápida',
        'fr': 'Course rapide',
        'de': 'Schneller Lauf',
        'it': 'Corsa veloce',
        'nl': 'Snelle run',
        'da': 'Hurtigt løb',
        'nb': 'Rask løping',
        'ru': 'Быстрый бег',
        'pt': 'Corrida rápida',
        'ja': '速いラン',
        'zh': '快速跑',
        'vi': 'Chạy nhanh',
        'ar': 'جري سريع',
        'th': 'วิ่งเร็ว',
      });

  String planFinishRunLabel() => _t({
        'ko': '피니시 달리기',
        'en': 'Finishing run',
        'es': 'Carrera final',
        'fr': 'Course finale',
        'de': 'Abschlusslauf',
        'it': 'Corsa finale',
        'nl': 'Eindsprint',
        'da': 'Afsluttende løb',
        'nb': 'Avsluttende løp',
        'ru': 'Финальный бег',
        'pt': 'Corrida final',
        'ja': 'フィニッシュラン',
        'zh': '冲刺跑',
        'vi': 'Chạy nước rút',
        'ar': 'جري ختامي',
        'th': 'วิ่งปิดท้าย',
      });

  // ---- Screen 3 ----
  List<EmphasisTextSpan> s3TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('속도와 시간을 보고\n'),
          EmphasisTextSpan('루틴에 맞춰', isRed: true),
          EmphasisTextSpan(' 운동해보세요'),
        ],
        'en': const [
          EmphasisTextSpan('Check speed & time,\n'),
          EmphasisTextSpan('follow your routine', isRed: true),
          EmphasisTextSpan(' as you train.'),
        ],
        'es': const [
          EmphasisTextSpan('Mira velocidad y tiempo,\n'),
          EmphasisTextSpan('sigue tu rutina', isRed: true),
          EmphasisTextSpan(' al entrenar.'),
        ],
        'fr': const [
          EmphasisTextSpan('Regardez la vitesse et le temps,\n'),
          EmphasisTextSpan('suivez votre séance', isRed: true),
          EmphasisTextSpan(' pendant l’entraînement.'),
        ],
        'de': const [
          EmphasisTextSpan('Sieh Tempo & Zeit,\n'),
          EmphasisTextSpan('trainiere nach Routine', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'it': const [
          EmphasisTextSpan('Guarda velocità e tempo,\n'),
          EmphasisTextSpan('segui la routine', isRed: true),
          EmphasisTextSpan(' mentre ti alleni.'),
        ],
        'nl': const [
          EmphasisTextSpan('Bekijk snelheid en tijd,\n'),
          EmphasisTextSpan('train volgens je routine', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'da': const [
          EmphasisTextSpan('Se hastighed og tid,\n'),
          EmphasisTextSpan('træn efter rutinen', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'nb': const [
          EmphasisTextSpan('Se hastighet og tid,\n'),
          EmphasisTextSpan('tren etter rutinen', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ru': const [
          EmphasisTextSpan('Смотри скорость и время,\n'),
          EmphasisTextSpan('тренируйся по рутине', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'pt': const [
          EmphasisTextSpan('Veja velocidade e tempo,\n'),
          EmphasisTextSpan('treine no ritmo da rotina', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ja': const [
          EmphasisTextSpan('速度と時間を見て\n'),
          EmphasisTextSpan('ルーティン通り', isRed: true),
          EmphasisTextSpan('に運動しよう'),
        ],
        'zh': const [
          EmphasisTextSpan('看速度和时间\n'),
          EmphasisTextSpan('按训练计划', isRed: true),
          EmphasisTextSpan('完成训练'),
        ],
        'vi': const [
          EmphasisTextSpan('Xem tốc độ và thời gian,\n'),
          EmphasisTextSpan('tập theo đúng chương trình', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ar': const [
          EmphasisTextSpan('راقب السرعة والوقت\n'),
          EmphasisTextSpan('واتبع روتينك', isRed: true),
          EmphasisTextSpan(' أثناء التمرين'),
        ],
        'th': const [
          EmphasisTextSpan('ดูความเร็วและเวลา\n'),
          EmphasisTextSpan('ออกกำลังกายตามรูทีน', isRed: true),
          EmphasisTextSpan('ของคุณ'),
        ],
      });

  String chipNextSpeed(String v) => _t({
        'ko': '다음 {v}',
        'en': 'Next {v}',
        'es': 'Siguiente {v}',
        'fr': 'Suivant {v}',
        'de': 'Als Nächstes {v}',
        'it': 'Prossimo {v}',
        'nl': 'Volgende {v}',
        'da': 'Næste {v}',
        'nb': 'Neste {v}',
        'ru': 'Далее {v}',
        'pt': 'Próximo {v}',
        'ja': '次は {v}',
        'zh': '下一项 {v}',
        'vi': 'Tiếp theo {v}',
        'ar': 'التالي {v}',
        'th': 'ถัดไป {v}',
      }).replaceAll('{v}', v);

  String chipIncline(String v) => _t({
        'ko': '{v} 경사도',
        'en': '{v} incline',
        'es': 'Inclinación {v}',
        'fr': 'Inclinaison {v}',
        'de': '{v} Steigung',
        'it': 'Inclinazione {v}',
        'nl': '{v} helling',
        'da': '{v} hældning',
        'nb': '{v} stigning',
        'ru': 'Наклон {v}',
        'pt': 'Inclinação {v}',
        'ja': '{v} 傾斜',
        'zh': '{v} 坡度',
        'vi': 'Độ dốc {v}',
        'ar': 'ميل {v}',
        'th': 'ความชัน {v}',
      }).replaceAll('{v}', v);

  // ---- Screen 4 ----
  List<EmphasisTextSpan> s4TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('운동이 끝난 후엔\n'),
          EmphasisTextSpan('그동안 완료한 운동들을 ', isRed: true),
          EmphasisTextSpan('기록하세요'),
        ],
        'en': const [
          EmphasisTextSpan('After your workout,\n'),
          EmphasisTextSpan('track what you completed', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'es': const [
          EmphasisTextSpan('Después de entrenar,\n'),
          EmphasisTextSpan('registra lo que completaste', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'fr': const [
          EmphasisTextSpan('Après l’entraînement,\n'),
          EmphasisTextSpan('enregistrez vos séances', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'de': const [
          EmphasisTextSpan('Nach dem Training,\n'),
          EmphasisTextSpan('halte deine Workouts fest', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'it': const [
          EmphasisTextSpan('Dopo l’allenamento,\n'),
          EmphasisTextSpan('registra ciò che hai completato', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'nl': const [
          EmphasisTextSpan('Na je workout,\n'),
          EmphasisTextSpan('leg je voltooide trainingen vast', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'da': const [
          EmphasisTextSpan('Efter træningen,\n'),
          EmphasisTextSpan('registrér dine gennemførte træninger', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'nb': const [
          EmphasisTextSpan('Etter økten,\n'),
          EmphasisTextSpan('registrer treningen du fullførte', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ru': const [
          EmphasisTextSpan('После тренировки,\n'),
          EmphasisTextSpan('сохраняй выполненные тренировки', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'pt': const [
          EmphasisTextSpan('Depois do treino,\n'),
          EmphasisTextSpan('registre o que você concluiu', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ja': const [
          EmphasisTextSpan('運動が終わったら\n'),
          EmphasisTextSpan('完了した運動を記録', isRed: true),
          EmphasisTextSpan('しよう'),
        ],
        'zh': const [
          EmphasisTextSpan('训练结束后\n'),
          EmphasisTextSpan('记录已完成的训练', isRed: true),
          EmphasisTextSpan(''),
        ],
        'vi': const [
          EmphasisTextSpan('Sau khi tập xong,\n'),
          EmphasisTextSpan('ghi lại những buổi đã hoàn thành', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'ar': const [
          EmphasisTextSpan('بعد التمرين،\n'),
          EmphasisTextSpan('سجّل ما أنجزته', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'th': const [
          EmphasisTextSpan('หลังออกกำลังกายเสร็จ\n'),
          EmphasisTextSpan('บันทึกสิ่งที่คุณทำสำเร็จ', isRed: true),
          EmphasisTextSpan(''),
        ],
      });

  // History list mock strings
  List<({String title, String subtitle})> historyItems() => [
        (
          title: historyTreadmillRoutineTitle(1),
          subtitle: _historySubRun(time: '30:00', dist: '4.52', avg: '8.5'),
        ),
        (
          title: historyTreadmillRoutineTitle(2),
          subtitle: _historySubRun(time: '15:00', dist: '2.4', avg: '5.0'),
        ),
        (
          title: historyTreadmillRoutineTitle(3),
          subtitle: _historySubRun(time: '20:00', dist: '5.8', avg: '7.5'),
        ),
        (
          title: historyCycleRoutineTitle(2),
          subtitle: historySubCycle(),
        ),
        (
          title: historyStairRoutineTitle(1),
          subtitle: historySubStair(),
        ),
      ];

  String historyWeeklyConsistencyLabel() => _t({
        'ko': '주간 꾸준함',
        'en': 'Weekly consistency',
        'es': 'Constancia semanal',
        'fr': 'Régularité hebdomadaire',
        'de': 'Wöchentliche Konstanz',
        'it': 'Costanza settimanale',
        'nl': 'Wekelijkse regelmaat',
        'da': 'Ugentlig kontinuitet',
        'nb': 'Ukentlig kontinuitet',
        'ru': 'Регулярность за неделю',
        'pt': 'Consistência semanal',
        'ja': '週間の継続状況',
        'zh': '每周坚持情况',
        'vi': 'Duy trì hằng tuần',
        'ar': 'الاستمرارية الأسبوعية',
        'th': 'ความสม่ำเสมอรายสัปดาห์',
      });

  String historyWeekStreakLabel(int n) {
    final template = _t({
      'ko': '🔥 {n}주 연속',
      'en': '🔥 {n}-week streak',
      'es': '🔥 Racha de {n} semanas',
      'fr': '🔥 Série de {n} semaines',
      'de': '🔥 {n} Wochen in Folge',
      'it': '🔥 Serie di {n} settimane',
      'nl': '🔥 {n} weken op rij',
      'da': '🔥 {n} uger i træk',
      'nb': '🔥 {n} uker på rad',
      'ru': '🔥 {n} недель подряд',
      'pt': '🔥 Sequência de {n} semanas',
      'ja': '🔥 {n}週間連続',
      'zh': '🔥 连续{n}周',
      'vi': '🔥 Chuỗi {n} tuần',
      'ar': '🔥 {n} أسبوعًا متتاليًا',
      'th': '🔥 ต่อเนื่อง {n} สัปดาห์',
    });
    return template.replaceAll('{n}', _number(n));
  }

  String historyTreadmillRoutineTitle(int n) => _numberedLabel(
        n,
        {
          'ko': '러닝 인터벌 루틴 {n}',
          'en': 'Treadmill interval routine {n}',
          'es': 'Intervalos en cinta {n}',
          'fr': 'Fractionné sur tapis {n}',
          'de': 'Laufband-Intervall {n}',
          'it': 'Intervalli su tapis roulant {n}',
          'nl': 'Loopbandinterval {n}',
          'da': 'Løbebåndsinterval {n}',
          'nb': 'Tredemølleintervall {n}',
          'ru': 'Интервалы на дорожке {n}',
          'pt': 'Intervalos na esteira {n}',
          'ja': 'トレッドミル・インターバル {n}',
          'zh': '跑步机间歇训练 {n}',
          'vi': 'Interval máy chạy bộ {n}',
          'ar': 'فترات جهاز المشي {n}',
          'th': 'อินเทอร์วัลลู่วิ่ง {n}',
        },
      );

  String historyCycleRoutineTitle(int n) => _numberedLabel(
        n,
        {
          'ko': '사이클 인터벌 루틴 {n}',
          'en': 'Cycle interval routine {n}',
          'es': 'Intervalos en bicicleta {n}',
          'fr': 'Fractionné vélo {n}',
          'de': 'Fahrrad-Intervall {n}',
          'it': 'Intervalli in bici {n}',
          'nl': 'Fietsinterval {n}',
          'da': 'Cykelinterval {n}',
          'nb': 'Sykkelintervall {n}',
          'ru': 'Велоинтервалы {n}',
          'pt': 'Intervalos na bicicleta {n}',
          'ja': 'バイク・インターバル {n}',
          'zh': '单车间歇训练 {n}',
          'vi': 'Interval xe đạp {n}',
          'ar': 'فترات الدراجة {n}',
          'th': 'อินเทอร์วัลจักรยาน {n}',
        },
      );

  String historyStairRoutineTitle(int n) => _numberedLabel(
        n,
        {
          'ko': '천국의 계단 인터벌 루틴 {n}',
          'en': 'Stair climber interval routine {n}',
          'es': 'Intervalos en escaladora {n}',
          'fr': 'Fractionné escalier {n}',
          'de': 'Treppensteiger-Intervall {n}',
          'it': 'Intervalli su stair climber {n}',
          'nl': 'Traptrainerinterval {n}',
          'da': 'Trappemaskineinterval {n}',
          'nb': 'Trappemaskinintervall {n}',
          'ru': 'Интервалы на степпере {n}',
          'pt': 'Intervalos na escada {n}',
          'ja': 'ステアクライマー・インターバル {n}',
          'zh': '登阶机间歇训练 {n}',
          'vi': 'Interval máy leo cầu thang {n}',
          'ar': 'فترات جهاز الدرج {n}',
          'th': 'อินเทอร์วัลเครื่องขึ้นบันได {n}',
        },
      );

  String _historySubRun({
    required String time,
    required String dist,
    required String avg,
  }) {
    final template = _t({
      'ko': '{time} • {dist} km • 평균 {avg} km/h',
      'en': '{time} • {dist} km • Avg. {avg} km/h',
      'es': '{time} • {dist} km • Prom. {avg} km/h',
      'fr': '{time} • {dist} km • Moy. {avg} km/h',
      'de': '{time} • {dist} km • Ø {avg} km/h',
      'it': '{time} • {dist} km • Media {avg} km/h',
      'nl': '{time} • {dist} km • Gem. {avg} km/h',
      'da': '{time} • {dist} km • Gns. {avg} km/t',
      'nb': '{time} • {dist} km • Snitt {avg} km/t',
      'ru': '{time} • {dist} km • Ср. {avg} km/h',
      'pt': '{time} • {dist} km • Média {avg} km/h',
      'ja': '{time} • {dist} km • 平均 {avg} km/h',
      'zh': '{time} • {dist} km • 平均 {avg} km/h',
      'vi': '{time} • {dist} km • TB {avg} km/h',
      'ar': '{time} • {dist} km • متوسط {avg} km/h',
      'th': '{time} • {dist} km • เฉลี่ย {avg} km/h',
    });
    return template
        .replaceAll('{time}', time)
        .replaceAll('{dist}', dist)
        .replaceAll('{avg}', avg);
  }

  String historySubCycle() => _t({
        'ko': '30:00 • 평균 RPM 75',
        'en': '30:00 • Avg RPM 75',
        'es': '30:00 • RPM prom. 75',
        'fr': '30:00 • RPM moy. 75',
        'de': '30:00 • Ø RPM 75',
        'it': '30:00 • RPM medi 75',
        'nl': '30:00 • Gem. RPM 75',
        'da': '30:00 • Gns. RPM 75',
        'nb': '30:00 • Snitt RPM 75',
        'ru': '30:00 • Ср. RPM 75',
        'pt': '30:00 • RPM méd. 75',
        'ja': '30:00 • 平均 RPM 75',
        'zh': '30:00 • 平均 RPM 75',
        'vi': '30:00 • RPM TB 75',
        'ar': '30:00 • متوسط RPM 75',
        'th': '30:00 • RPM เฉลี่ย 75',
      });

  String historySubStair() => _t({
        'ko': '30:00 • 평균 레벨 8.5',
        'en': '30:00 • Avg Level 8.5',
        'es': '30:00 • Nivel prom. 8.5',
        'fr': '30:00 • Niveau moy. 8.5',
        'de': '30:00 • Ø Stufe 8.5',
        'it': '30:00 • Livello medio 8.5',
        'nl': '30:00 • Gem. niveau 8.5',
        'da': '30:00 • Gns. niveau 8.5',
        'nb': '30:00 • Snittnivå 8.5',
        'ru': '30:00 • Ср. уровень 8.5',
        'pt': '30:00 • Nível méd. 8.5',
        'ja': '30:00 • 平均 レベル 8.5',
        'zh': '30:00 • 平均 等级 8.5',
        'vi': '30:00 • Cấp TB 8.5',
        'ar': '30:00 • متوسط المستوى 8.5',
        'th': '30:00 • ระดับเฉลี่ย 8.5',
      });

  // ---- Screen 5 ----
  List<EmphasisTextSpan> s5TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('자신의 '),
          EmphasisTextSpan('운동 레벨', isRed: true),
          EmphasisTextSpan('을 선택해 주세요'),
        ],
        'en': const [
          EmphasisTextSpan('Select your '),
          EmphasisTextSpan('fitness level', isRed: true),
          EmphasisTextSpan('.'),
        ],
        'es': const [
          EmphasisTextSpan('Elige tu '),
          EmphasisTextSpan('nivel', isRed: true),
          EmphasisTextSpan(' de entrenamiento'),
        ],
        'fr': const [
          EmphasisTextSpan('Choisissez votre '),
          EmphasisTextSpan('niveau', isRed: true),
          EmphasisTextSpan(''),
        ],
        'de': const [
          EmphasisTextSpan('Wähle dein '),
          EmphasisTextSpan('Fitnesslevel', isRed: true),
          EmphasisTextSpan(''),
        ],
        'it': const [
          EmphasisTextSpan('Seleziona il tuo '),
          EmphasisTextSpan('livello', isRed: true),
          EmphasisTextSpan(''),
        ],
        'nl': const [
          EmphasisTextSpan('Kies je '),
          EmphasisTextSpan('niveau', isRed: true),
          EmphasisTextSpan(''),
        ],
        'da': const [
          EmphasisTextSpan('Vælg dit '),
          EmphasisTextSpan('niveau', isRed: true),
          EmphasisTextSpan(''),
        ],
        'nb': const [
          EmphasisTextSpan('Velg ditt '),
          EmphasisTextSpan('nivå', isRed: true),
          EmphasisTextSpan(''),
        ],
        'ru': const [
          EmphasisTextSpan('Выбери '),
          EmphasisTextSpan('уровень', isRed: true),
          EmphasisTextSpan(''),
        ],
        'pt': const [
          EmphasisTextSpan('Escolha seu '),
          EmphasisTextSpan('nível', isRed: true),
          EmphasisTextSpan(''),
        ],
        'ja': const [
          EmphasisTextSpan('自分の'),
          EmphasisTextSpan('レベル', isRed: true),
          EmphasisTextSpan('を選択してください'),
        ],
        'zh': const [
          EmphasisTextSpan('选择你的'),
          EmphasisTextSpan('训练水平', isRed: true),
          EmphasisTextSpan(''),
        ],
        'vi': const [
          EmphasisTextSpan('Chọn '),
          EmphasisTextSpan('cấp độ', isRed: true),
          EmphasisTextSpan(' của bạn'),
        ],
        'ar': const [
          EmphasisTextSpan('اختر '),
          EmphasisTextSpan('مستواك', isRed: true),
          EmphasisTextSpan(''),
        ],
        'th': const [
          EmphasisTextSpan('เลือก'),
          EmphasisTextSpan('ระดับ', isRed: true),
          EmphasisTextSpan('ของคุณ'),
        ],
      });

  String levelBeginnerTitle() => _t({
        'ko': '초급',
        'en': 'Beginner',
        'es': 'Principiante',
        'fr': 'Débutant',
        'de': 'Anfänger',
        'it': 'Principiante',
        'nl': 'Beginner',
        'da': 'Begynder',
        'nb': 'Nybegynner',
        'ru': 'Новичок',
        'pt': 'Iniciante',
        'ja': '初級',
        'zh': '初级',
        'vi': 'Cơ bản',
        'ar': 'مبتدئ',
        'th': 'ระดับเริ่มต้น',
      });

  String levelIntermediateTitle() => _t({
        'ko': '중급',
        'en': 'Intermediate',
        'es': 'Intermedio',
        'fr': 'Intermédiaire',
        'de': 'Mittel',
        'it': 'Intermedio',
        'nl': 'Gemiddeld',
        'da': 'Mellem',
        'nb': 'Middels',
        'ru': 'Средний',
        'pt': 'Intermediário',
        'ja': '中級',
        'zh': '中级',
        'vi': 'Trung cấp',
        'ar': 'متوسط',
        'th': 'ระดับกลาง',
      });

  String levelAdvancedTitle() => _t({
        'ko': '고급',
        'en': 'Advanced',
        'es': 'Avanzado',
        'fr': 'Avancé',
        'de': 'Fortgeschritten',
        'it': 'Avanzato',
        'nl': 'Gevorderd',
        'da': 'Avanceret',
        'nb': 'Avansert',
        'ru': 'Продвинутый',
        'pt': 'Avançado',
        'ja': '上級',
        'zh': '高级',
        'vi': 'Nâng cao',
        'ar': 'متقدم',
        'th': 'ขั้นสูง',
      });

  String levelBeginnerSub() => _t({
        'ko': '유산소 운동의 경험이 적어요',
        'en': 'I’m new to cardio',
        'es': 'Tengo poca experiencia',
        'fr': "J’ai peu d’expérience",
        'de': 'Wenig Erfahrung',
        'it': 'Poca esperienza',
        'nl': 'Weinig ervaring',
        'da': 'Lidt erfaring',
        'nb': 'Lite erfaring',
        'ru': 'Мало опыта',
        'pt': 'Pouca experiência',
        'ja': '経験が少ない',
        'zh': '经验较少',
        'vi': 'Ít kinh nghiệm',
        'ar': 'خبرة قليلة',
        'th': 'ประสบการณ์น้อย',
      });

  String levelIntermediateSub() => _t({
        'ko': '유산소 운동을 해봤고 체력이 좋아요',
        'en': 'I’ve done cardio and feel fit',
        'es': 'He hecho cardio y tengo buena forma',
        'fr': "J’ai déjà fait du cardio",
        'de': 'Schon Cardio gemacht',
        'it': 'Ho fatto cardio e sto bene',
        'nl': 'Ik heb cardio gedaan en ben fit',
        'da': 'Jeg har prøvet cardio',
        'nb': 'Jeg har prøvd cardio',
        'ru': 'Делал кардио, форма хорошая',
        'pt': 'Já fiz cardio e tenho bom preparo',
        'ja': '経験があって体力もある',
        'zh': '有经验且体能不错',
        'vi': 'Đã tập cardio và thể lực tốt',
        'ar': 'جربت الكارديو ولياقة جيدة',
        'th': 'เคยทำคาร์ดิโอและฟิตพอสมควร',
      });

  String levelAdvancedSub() => _t({
        'ko': '유산소 운동을 꾸준히 오래 해왔어요',
        'en': 'I’ve trained consistently for a long time',
        'es': 'He entrenado de forma constante',
        'fr': "Je m’entraîne régulièrement",
        'de': 'Trainiere schon lange',
        'it': 'Mi alleno con costanza da tempo',
        'nl': 'Ik train al lang consistent',
        'da': 'Jeg har trænet længe',
        'nb': 'Jeg har trent lenge',
        'ru': 'Давно тренируюсь регулярно',
        'pt': 'Treino de forma consistente há tempos',
        'ja': '継続的に長くやっている',
        'zh': '长期坚持训练',
        'vi': 'Tập đều đặn lâu dài',
        'ar': 'أتدرب بانتظام منذ مدة',
        'th': 'ออกกำลังกายสม่ำเสมอมานาน',
      });

  // ---- Screen 6 ----
  List<EmphasisTextSpan> s6TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('사용할 '),
          EmphasisTextSpan('단위', isRed: true),
          EmphasisTextSpan('를 선택해 주세요'),
        ],
        'en': const [
          EmphasisTextSpan('Choose your '),
          EmphasisTextSpan('units', isRed: true),
          EmphasisTextSpan(''),
        ],
        'es': const [
          EmphasisTextSpan('Elige tus '),
          EmphasisTextSpan('unidades', isRed: true),
        ],
        'fr': const [
          EmphasisTextSpan('Choisissez vos '),
          EmphasisTextSpan('unités', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('Wähle deine '),
          EmphasisTextSpan('Einheiten', isRed: true),
        ],
        'it': const [
          EmphasisTextSpan('Scegli le '),
          EmphasisTextSpan('unità', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('Kies je '),
          EmphasisTextSpan('eenheden', isRed: true),
        ],
        'da': const [
          EmphasisTextSpan('Vælg dine '),
          EmphasisTextSpan('enheder', isRed: true),
        ],
        'nb': const [
          EmphasisTextSpan('Velg dine '),
          EmphasisTextSpan('enheter', isRed: true),
        ],
        'ru': const [
          EmphasisTextSpan('Выбери '),
          EmphasisTextSpan('единицы измерения', isRed: true),
        ],
        'pt': const [
          EmphasisTextSpan('Escolha suas '),
          EmphasisTextSpan('unidades', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('使用する'),
          EmphasisTextSpan('単位', isRed: true),
          EmphasisTextSpan('を選択'),
        ],
        'zh': const [
          EmphasisTextSpan('选择使用的'),
          EmphasisTextSpan('单位', isRed: true),
        ],
        'vi': const [
          EmphasisTextSpan('Chọn '),
          EmphasisTextSpan('đơn vị', isRed: true),
          EmphasisTextSpan(' của bạn'),
        ],
        'ar': const [
          EmphasisTextSpan('اختر '),
          EmphasisTextSpan('وحدات القياس', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('เลือก'),
          EmphasisTextSpan('หน่วย', isRed: true),
          EmphasisTextSpan('ที่ต้องการ'),
        ],
      });

  String s6Helper() => _t({
        'ko': '설정에서 언제든지 변경할 수 있어요',
        'en': 'You can change this later in Settings.',
        'es': 'Puedes cambiarlo luego en Ajustes.',
        'fr': 'Modifiable plus tard dans Réglages.',
        'de': 'Später in den Einstellungen änderbar.',
        'it': 'Puoi cambiarlo più tardi nelle Impostazioni.',
        'nl': 'Je kunt dit later wijzigen in Instellingen.',
        'da': 'Du kan ændre det senere i Indstillinger.',
        'nb': 'Du kan endre dette senere i Innstillinger.',
        'ru': 'Можно изменить позже в настройках.',
        'pt': 'Você pode alterar depois em Ajustes.',
        'ja': '後で設定で変更できます',
        'zh': '可在设置中随时更改',
        'vi': 'Bạn có thể đổi sau trong Cài đặt.',
        'ar': 'يمكنك تغييره لاحقًا من الإعدادات.',
        'th': 'คุณเปลี่ยนได้ภายหลังในตั้งค่า',
      });

  // ---- Screen 7 ----
  List<EmphasisTextSpan> s7TitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('이제 '),
          EmphasisTextSpan('시작', isRed: true),
          EmphasisTextSpan('하세요!'),
        ],
        'en': const [
          EmphasisTextSpan('Now '),
          EmphasisTextSpan('start', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'es': const [
          EmphasisTextSpan('¡Ahora, '),
          EmphasisTextSpan('empieza', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'fr': const [
          EmphasisTextSpan('C’est parti, '),
          EmphasisTextSpan('commence', isRed: true),
          EmphasisTextSpan(' !'),
        ],
        'de': const [
          EmphasisTextSpan('Jetzt '),
          EmphasisTextSpan('starten', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'it': const [
          EmphasisTextSpan('Ora '),
          EmphasisTextSpan('inizia', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'nl': const [
          EmphasisTextSpan('Ga nu '),
          EmphasisTextSpan('van start', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'da': const [
          EmphasisTextSpan('Kom nu '),
          EmphasisTextSpan('i gang', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'nb': const [
          EmphasisTextSpan('Nå kan du '),
          EmphasisTextSpan('starte', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'ru': const [
          EmphasisTextSpan('Теперь '),
          EmphasisTextSpan('начинай', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'pt': const [
          EmphasisTextSpan('Agora, '),
          EmphasisTextSpan('comece', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'ja': const [
          EmphasisTextSpan('さあ、'),
          EmphasisTextSpan('始めよう', isRed: true),
          EmphasisTextSpan('！'),
        ],
        'zh': const [
          EmphasisTextSpan('现在就'),
          EmphasisTextSpan('开始', isRed: true),
          EmphasisTextSpan('吧！'),
        ],
        'vi': const [
          EmphasisTextSpan('Giờ thì '),
          EmphasisTextSpan('bắt đầu', isRed: true),
          EmphasisTextSpan(' thôi!'),
        ],
        'ar': const [
          EmphasisTextSpan('والآن '),
          EmphasisTextSpan('ابدأ', isRed: true),
          EmphasisTextSpan('!'),
        ],
        'th': const [
          EmphasisTextSpan('ตอนนี้ '),
          EmphasisTextSpan('เริ่มเลย', isRed: true),
          EmphasisTextSpan('!'),
        ],
      });

  // Subtitle is a rich text where a phrase is red.
  String s7SubtitleLine1() => _t({
        'ko': 'Valcue와 함께\n',
        'en': 'With Valcue,\n',
        'es': 'Con Valcue,\n',
        'fr': 'Avec Valcue,\n',
        'de': 'Mit Valcue,\n',
        'it': 'Con Valcue,\n',
        'nl': 'Met Valcue,\n',
        'da': 'Med Valcue,\n',
        'nb': 'Med Valcue,\n',
        'ru': 'С Valcue,\n',
        'pt': 'Com o Valcue,\n',
        'ja': 'Valcueと一緒に\n',
        'zh': '和 Valcue 一起\n',
        'vi': 'Cùng Valcue,\n',
        'ar': 'مع Valcue،\n',
        'th': 'ไปกับ Valcue\n',
      });

  String s7SubtitleRedPhrase() => _t({
        'ko': '효율적인 유산소',
        'en': 'efficient cardio',
        'es': 'cardio eficiente',
        'fr': 'cardio efficace',
        'de': 'effizientes Cardio',
        'it': 'cardio efficiente',
        'nl': 'efficiënte cardio',
        'da': 'effektiv cardio',
        'nb': 'effektiv cardio',
        'ru': 'эффективное кардио',
        'pt': 'cardio eficiente',
        'ja': '効率的な有酸素',
        'zh': '高效有氧',
        'vi': 'cardio hiệu quả',
        'ar': 'كارديو فعّال',
        'th': 'คาร์ดิโออย่างมีประสิทธิภาพ',
      });

  String s7SubtitleTail() => _t({
        'ko': '를 즐겨보세요',
        'en': ' and enjoy it.',
        'es': ' y disfrútalo.',
        'fr': ' et profitez-en.',
        'de': ' und hab Spaß dabei.',
        'it': ' e goditelo.',
        'nl': ' en geniet ervan.',
        'da': ' og nyd det.',
        'nb': ' og nyt det.',
        'ru': ' и получай удовольствие.',
        'pt': ' e aproveite.',
        'ja': 'を楽しみましょう',
        'zh': '尽情享受吧',
        'vi': ' và tận hưởng nhé.',
        'ar': ' واستمتع به.',
        'th': 'แล้วสนุกไปด้วยกัน',
      });

  // ---- New AI Intro Screen ----
  List<EmphasisTextSpan> aiIntroTitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('나만을 위한\n'),
          EmphasisTextSpan('맞춤 루틴 ', isRed: true),
          EmphasisTextSpan('생성'),
        ],
        'en': const [
          EmphasisTextSpan('Custom '),
          EmphasisTextSpan('Routine ', isRed: true),
          EmphasisTextSpan('generator'),
        ],
        'es': const [
          EmphasisTextSpan('Crea tu propia\n'),
          EmphasisTextSpan('rutina personalizada', isRed: true),
        ],
        'fr': const [
          EmphasisTextSpan('Créez votre propre\n'),
          EmphasisTextSpan('séance personnalisée', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('Erstelle dein\n'),
          EmphasisTextSpan('individuelles Training', isRed: true),
        ],
        'it': const [
          EmphasisTextSpan('Crea la tua\n'),
          EmphasisTextSpan('routine personalizzata', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('Maak je eigen\n'),
          EmphasisTextSpan('persoonlijke routine', isRed: true),
        ],
        'da': const [
          EmphasisTextSpan('Skab din egen\n'),
          EmphasisTextSpan('personlige rutine', isRed: true),
        ],
        'nb': const [
          EmphasisTextSpan('Lag din egen\n'),
          EmphasisTextSpan('personlig rutine', isRed: true),
        ],
        'ru': const [
          EmphasisTextSpan('Создай свою\n'),
          EmphasisTextSpan('персональную программу', isRed: true),
        ],
        'pt': const [
          EmphasisTextSpan('Crie sua própria\n'),
          EmphasisTextSpan('rotina personalizada', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('自分だけの\n'),
          EmphasisTextSpan('カスタムルーティン', isRed: true),
          EmphasisTextSpan('を作成'),
        ],
        'zh': const [
          EmphasisTextSpan('生成专属\n'),
          EmphasisTextSpan('定制训练计划', isRed: true),
        ],
        'vi': const [
          EmphasisTextSpan('Tạo '),
          EmphasisTextSpan('bài tập tùy chỉnh', isRed: true),
          EmphasisTextSpan('\ndành riêng cho bạn'),
        ],
        'ar': const [
          EmphasisTextSpan('أنشئ روتينك\n'),
          EmphasisTextSpan('المخصص لك', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('สร้างรูทีน\n'),
          EmphasisTextSpan('เฉพาะบุคคลสำหรับคุณ', isRed: true),
        ],
      });

  String aiIntroBody() => _t({
        'ko': '원하는 기구와 시간, 강도를 고르면\n선택에 맞는 루틴을 만들어 드립니다.',
        'en':
            'Choose your machine, time, and intensity.\nWe’ll build a routine around your choices.',
        'es':
            'Elige máquina, tiempo e intensidad.\nCrearemos una rutina según tus preferencias.',
        'fr':
            'Choisissez la machine, la durée et l’intensité.\nNous créerons une séance selon vos choix.',
        'de':
            'Wähle Gerät, Dauer und Intensität.\nWir erstellen ein Training nach deinen Vorgaben.',
        'it':
            'Scegli attrezzo, durata e intensità.\nCreeremo una routine in base alle tue scelte.',
        'nl':
            'Kies apparaat, tijd en intensiteit.\nWe maken een routine op basis van je keuzes.',
        'da':
            'Vælg maskine, tid og intensitet.\nVi laver en rutine ud fra dine valg.',
        'nb':
            'Velg apparat, tid og intensitet.\nVi lager en rutine basert på valgene dine.',
        'ru':
            'Выбери тренажёр, время и нагрузку.\nМы составим тренировку по твоим параметрам.',
        'pt':
            'Escolha aparelho, tempo e intensidade.\nCriaremos uma rotina com base nas suas escolhas.',
        'ja': '器具・時間・強度を選ぶだけ。\n選択内容に合わせてルーティンを作成します。',
        'zh': '只需选择器械、时间和强度。\n我们会根据你的选择生成定制训练。',
        'vi':
            'Chọn máy, thời gian và cường độ.\nChúng tôi sẽ tạo bài tập theo lựa chọn của bạn.',
        'ar': 'اختر الجهاز والمدة والشدة.\nسننشئ تمرينًا يناسب اختياراتك.',
        'th':
            'เลือกเครื่อง เวลา และความเข้มข้น\nเราจะสร้างรูทีนตามตัวเลือกของคุณ',
      });

  String aiGenerationSemantics() => _t({
        'ko': '러닝머신, 30분, 중급 조건으로 맞춤 인터벌 루틴 생성',
        'en':
            'Create a custom interval routine from treadmill, 30 minutes, and intermediate inputs',
        'es':
            'Crear una rutina por intervalos para cinta, 30 minutos y nivel intermedio',
        'fr':
            'Créer une séance fractionnée sur tapis de 30 minutes, niveau intermédiaire',
        'de':
            'Individuelles Laufband-Intervall für 30 Minuten auf mittlerem Niveau erstellen',
        'it':
            'Crea una routine a intervalli sul tapis roulant di 30 minuti, livello intermedio',
        'nl': 'Maak een loopbandinterval van 30 minuten op gemiddeld niveau',
        'da':
            'Opret en tilpasset løbebåndsrutine på 30 minutter på mellemniveau',
        'nb':
            'Lag en tilpasset tredemøllerutine på 30 minutter på middels nivå',
        'ru':
            'Создать интервальную тренировку на дорожке на 30 минут для среднего уровня',
        'pt':
            'Criar uma rotina intervalada na esteira de 30 minutos, nível intermediário',
        'ja': 'トレッドミル・30分・中級の条件で専用インターバルを作成',
        'zh': '根据跑步机、30分钟和中级条件生成专属间歇训练',
        'vi':
            'Tạo bài interval máy chạy bộ 30 phút dành cho trình độ trung cấp',
        'ar': 'إنشاء تمرين فترات مخصص لجهاز المشي لمدة 30 دقيقة بمستوى متوسط',
        'th': 'สร้างรูทีนอินเทอร์วัลลู่วิ่ง 30 นาทีสำหรับระดับกลาง',
      });

  String aiTreadmillLabel() => _t({
        'ko': '러닝머신',
        'en': 'Treadmill',
        'es': 'Cinta',
        'fr': 'Tapis',
        'de': 'Laufband',
        'it': 'Tapis roulant',
        'nl': 'Loopband',
        'da': 'Løbebånd',
        'nb': 'Tredemølle',
        'ru': 'Беговая дорожка',
        'pt': 'Esteira',
        'ja': 'トレッドミル',
        'zh': '跑步机',
        'vi': 'Máy chạy bộ',
        'ar': 'جهاز المشي',
        'th': 'ลู่วิ่ง',
      });

  String aiCoreStatus() => _t({
        'ko': '조건 분석 · 인터벌 설계',
        'en': 'Analyze · Design intervals',
        'es': 'Analizar · Diseñar intervalos',
        'fr': 'Analyser · Créer les intervalles',
        'de': 'Analysieren · Intervalle planen',
        'it': 'Analisi · Creazione intervalli',
        'nl': 'Analyseren · Intervallen ontwerpen',
        'da': 'Analysér · Design intervaller',
        'nb': 'Analyser · Design intervaller',
        'ru': 'Анализ · План интервалов',
        'pt': 'Analisar · Criar intervalos',
        'ja': '条件を分析 · インターバルを設計',
        'zh': '分析条件 · 设计间歇',
        'vi': 'Phân tích · Thiết kế interval',
        'ar': 'تحليل الشروط · تصميم الفترات',
        'th': 'วิเคราะห์ · ออกแบบอินเทอร์วัล',
      });

  String aiCustomRoutineLabel() => _t({
        'ko': '맞춤 인터벌 루틴',
        'en': 'Custom interval routine',
        'es': 'Rutina por intervalos personalizada',
        'fr': 'Séance fractionnée personnalisée',
        'de': 'Individuelle Intervallroutine',
        'it': 'Routine a intervalli personalizzata',
        'nl': 'Persoonlijke intervalroutine',
        'da': 'Tilpasset intervalrutine',
        'nb': 'Tilpasset intervallrutine',
        'ru': 'Персональная интервальная программа',
        'pt': 'Rotina intervalada personalizada',
        'ja': '専用インターバルルーティン',
        'zh': '专属间歇训练计划',
        'vi': 'Bài interval riêng cho bạn',
        'ar': 'روتين فترات مخصص',
        'th': 'รูทีนอินเทอร์วัลเฉพาะคุณ',
      });

  String aiWalkMinutesLabel(int n) => _numberedLabel(n, {
        'ko': '걷기 {n}분',
        'en': 'Walk {n} min',
        'es': 'Caminar {n} min',
        'fr': 'Marche {n} min',
        'de': 'Gehen {n} Min.',
        'it': 'Cammina {n} min',
        'nl': 'Wandelen {n} min',
        'da': 'Gang {n} min',
        'nb': 'Gange {n} min',
        'ru': 'Ходьба {n} мин',
        'pt': 'Caminhar {n} min',
        'ja': 'ウォーク {n}分',
        'zh': '步行 {n}分钟',
        'vi': 'Đi bộ {n} phút',
        'ar': 'مشي {n} دقائق',
        'th': 'เดิน {n} นาที',
      });

  String aiRunMinutesLabel(int n) => _numberedLabel(n, {
        'ko': '달리기 {n}분',
        'en': 'Run {n} min',
        'es': 'Correr {n} min',
        'fr': 'Course {n} min',
        'de': 'Laufen {n} Min.',
        'it': 'Corri {n} min',
        'nl': 'Rennen {n} min',
        'da': 'Løb {n} min',
        'nb': 'Løping {n} min',
        'ru': 'Бег {n} мин',
        'pt': 'Correr {n} min',
        'ja': 'ラン {n}分',
        'zh': '跑步 {n}分钟',
        'vi': 'Chạy {n} phút',
        'ar': 'جري {n} دقائق',
        'th': 'วิ่ง {n} นาที',
      });

  String aiSetCountLabel(int n) => _numberedLabel(n, {
        'ko': '× {n}세트',
        'en': '× {n} sets',
        'es': '× {n} series',
        'fr': '× {n} séries',
        'de': '× {n} Runden',
        'it': '× {n} serie',
        'nl': '× {n} sets',
        'da': '× {n} sæt',
        'nb': '× {n} sett',
        'ru': '× {n} подходов',
        'pt': '× {n} séries',
        'ja': '× {n}セット',
        'zh': '× {n}组',
        'vi': '× {n} hiệp',
        'ar': '× {n} مجموعات',
        'th': '× {n} เซ็ต',
      });

  // ---- New Reminder Screen ----
  List<EmphasisTextSpan> reminderTitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('운동 습관을 위한\n'),
          EmphasisTextSpan('알림 설정', isRed: true),
        ],
        'en': const [
          EmphasisTextSpan('Build habits with\n'),
          EmphasisTextSpan('Reminders', isRed: true),
        ],
        'es': const [
          EmphasisTextSpan('Crea el hábito con\n'),
          EmphasisTextSpan('recordatorios', isRed: true),
        ],
        'fr': const [
          EmphasisTextSpan('Créez une habitude avec\n'),
          EmphasisTextSpan('des rappels', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('Gewohnheiten durch\n'),
          EmphasisTextSpan('Erinnerungen', isRed: true),
        ],
        'it': const [
          EmphasisTextSpan('Crea l’abitudine con\n'),
          EmphasisTextSpan('i promemoria', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('Bouw een gewoonte op met\n'),
          EmphasisTextSpan('herinneringen', isRed: true),
        ],
        'da': const [
          EmphasisTextSpan('Skab vanen med\n'),
          EmphasisTextSpan('påmindelser', isRed: true),
        ],
        'nb': const [
          EmphasisTextSpan('Bygg vanen med\n'),
          EmphasisTextSpan('påminnelser', isRed: true),
        ],
        'ru': const [
          EmphasisTextSpan('Закрепляй привычку с\n'),
          EmphasisTextSpan('напоминаниями', isRed: true),
        ],
        'pt': const [
          EmphasisTextSpan('Crie o hábito com\n'),
          EmphasisTextSpan('lembretes', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('運動習慣のために\n'),
          EmphasisTextSpan('リマインダーを設定', isRed: true),
        ],
        'zh': const [
          EmphasisTextSpan('用'),
          EmphasisTextSpan('提醒', isRed: true),
          EmphasisTextSpan('养成运动习惯'),
        ],
        'vi': const [
          EmphasisTextSpan('Tạo thói quen với\n'),
          EmphasisTextSpan('lời nhắc', isRed: true),
        ],
        'ar': const [
          EmphasisTextSpan('ابنِ عادتك مع\n'),
          EmphasisTextSpan('التذكيرات', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('สร้างนิสัยด้วย\n'),
          EmphasisTextSpan('การแจ้งเตือน', isRed: true),
        ],
      });

  String reminderBody() => _t({
        'ko': '잊지 않고 운동할 수 있도록 원하는 요일과 알림 시간을 설정해 주세요.',
        'en':
            'Schedule reminders on your preferred days and times to keep up your workout consistency.',
        'es':
            'Elige los días y la hora para no perder la constancia en tus entrenamientos.',
        'fr':
            'Choisissez les jours et l’heure pour garder le rythme de vos entraînements.',
        'de': 'Lege Tage und Uhrzeit fest, damit du regelmäßig trainierst.',
        'it': 'Scegli giorni e orario per allenarti con costanza.',
        'nl':
            'Kies dagen en een tijd om je trainingen consequent vol te houden.',
        'da': 'Vælg dage og tidspunkt, så du holder fast i din træning.',
        'nb': 'Velg dager og tidspunkt, så du holder treningen ved like.',
        'ru': 'Выбери дни и время, чтобы не пропускать тренировки.',
        'pt':
            'Escolha os dias e o horário para manter a constância nos treinos.',
        'ja': '運動を忘れないよう、希望する曜日と通知時刻を設定してください。',
        'zh': '选择提醒日期和时间，帮助你坚持运动。',
        'vi': 'Chọn ngày và giờ nhắc để duy trì việc tập luyện đều đặn.',
        'ar': 'اختر الأيام والوقت المناسبين لتستمر في ممارسة التمارين بانتظام.',
        'th': 'เลือกวันและเวลาแจ้งเตือน เพื่อให้ออกกำลังกายได้อย่างสม่ำเสมอ',
      });

  String reminderDaysLabel() => _t({
        'ko': '요일 선택',
        'en': 'Select Days',
        'es': 'Seleccionar días',
        'fr': 'Choisir les jours',
        'de': 'Tage auswählen',
        'it': 'Seleziona i giorni',
        'nl': 'Dagen kiezen',
        'da': 'Vælg dage',
        'nb': 'Velg dager',
        'ru': 'Выбери дни',
        'pt': 'Selecionar dias',
        'ja': '曜日を選択',
        'zh': '选择日期',
        'vi': 'Chọn ngày',
        'ar': 'اختر الأيام',
        'th': 'เลือกวัน',
      });

  String reminderTimeLabel() => _t({
        'ko': '시간 선택',
        'en': 'Select Time',
        'es': 'Seleccionar hora',
        'fr': 'Choisir l’heure',
        'de': 'Uhrzeit auswählen',
        'it': 'Seleziona l’ora',
        'nl': 'Tijd kiezen',
        'da': 'Vælg tidspunkt',
        'nb': 'Velg tidspunkt',
        'ru': 'Выбери время',
        'pt': 'Selecionar horário',
        'ja': '時刻を選択',
        'zh': '选择时间',
        'vi': 'Chọn giờ',
        'ar': 'اختر الوقت',
        'th': 'เลือกเวลา',
      });

  String ctaSetReminder() => _t({
        'ko': '알림 설정하고 계속하기',
        'en': 'Set Reminder & Continue',
        'es': 'Configurar y continuar',
        'fr': 'Définir et continuer',
        'de': 'Erinnerung einstellen',
        'it': 'Imposta e continua',
        'nl': 'Instellen en doorgaan',
        'da': 'Indstil og fortsæt',
        'nb': 'Angi og fortsett',
        'ru': 'Настроить и продолжить',
        'pt': 'Configurar e continuar',
        'ja': '通知を設定して続ける',
        'zh': '设置提醒并继续',
        'vi': 'Đặt lời nhắc và tiếp tục',
        'ar': 'اضبط التذكير وتابع',
        'th': 'ตั้งการแจ้งเตือนและไปต่อ',
      });

  String ctaSkipReminder() => _t({
        'ko': '나중에 설정하기',
        'en': 'Skip for now',
        'es': 'Configurar más tarde',
        'fr': 'Configurer plus tard',
        'de': 'Später einrichten',
        'it': 'Configura più tardi',
        'nl': 'Later instellen',
        'da': 'Indstil senere',
        'nb': 'Angi senere',
        'ru': 'Настроить позже',
        'pt': 'Configurar depois',
        'ja': 'あとで設定',
        'zh': '稍后设置',
        'vi': 'Để sau',
        'ar': 'الإعداد لاحقًا',
        'th': 'ตั้งค่าภายหลัง',
      });

  // ---- New Premium Screen ----
  List<EmphasisTextSpan> premiumTitleSpans() => _spans({
        'ko': const [
          EmphasisTextSpan('Valcue Pro로\n'),
          EmphasisTextSpan('더 강력하게', isRed: true),
        ],
        'en': const [
          EmphasisTextSpan('Go further with\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'es': const [
          EmphasisTextSpan('Llega más lejos con\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'fr': const [
          EmphasisTextSpan('Va plus loin avec\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'de': const [
          EmphasisTextSpan('Mehr erreichen mit\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'it': const [
          EmphasisTextSpan('Vai oltre con\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'nl': const [
          EmphasisTextSpan('Ga verder met\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'da': const [
          EmphasisTextSpan('Nå længere med\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'nb': const [
          EmphasisTextSpan('Nå lenger med\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'ru': const [
          EmphasisTextSpan('Больше возможностей с\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'pt': const [
          EmphasisTextSpan('Vá mais longe com\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'ja': const [
          EmphasisTextSpan('Valcue Proで\n'),
          EmphasisTextSpan('さらにパワフルに', isRed: true),
        ],
        'zh': const [
          EmphasisTextSpan('使用 '),
          EmphasisTextSpan('Valcue Pro', isRed: true),
          EmphasisTextSpan('\n解锁更强体验'),
        ],
        'vi': const [
          EmphasisTextSpan('Tiến xa hơn cùng\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'ar': const [
          EmphasisTextSpan('حقق المزيد مع\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
        'th': const [
          EmphasisTextSpan('ไปได้ไกลกว่าด้วย\n'),
          EmphasisTextSpan('Valcue Pro', isRed: true),
        ],
      });

  String premiumBullet1() => _t({
        'ko': '체중 기록 및 정밀 차트 분석 잠금해제',
        'en': 'Unlock weight logging and advanced trend chart',
        'es': 'Registro de peso y gráficos de tendencias avanzados',
        'fr': 'Suivi du poids et graphiques de tendance avancés',
        'de': 'Gewichtsprotokoll und erweiterte Trenddiagramme',
        'it': 'Registro del peso e grafici avanzati',
        'nl': 'Gewichtsregistratie en uitgebreide trendgrafieken',
        'da': 'Vægtlog og avancerede trendgrafer',
        'nb': 'Vektlogg og avanserte trendgrafer',
        'ru': 'Журнал веса и расширенные графики динамики',
        'pt': 'Registro de peso e gráficos avançados de tendência',
        'ja': '体重記録と詳細な推移グラフを利用',
        'zh': '解锁体重记录和高级趋势图表',
        'vi': 'Mở khóa nhật ký cân nặng và biểu đồ nâng cao',
        'ar': 'فتح سجل الوزن ومخططات الاتجاهات المتقدمة',
        'th': 'ปลดล็อกบันทึกน้ำหนักและกราฟแนวโน้มขั้นสูง',
      });

  String premiumBullet2() => _t({
        'ko': '맞춤 루틴 무제한 생성',
        'en': 'Generate unlimited personalized routines',
        'es': 'Rutinas personalizadas ilimitadas',
        'fr': 'Séances personnalisées illimitées',
        'de': 'Unbegrenzt individuelle Trainings erstellen',
        'it': 'Routine personalizzate illimitate',
        'nl': 'Onbeperkt persoonlijke routines maken',
        'da': 'Ubegrænsede personlige rutiner',
        'nb': 'Ubegrensede personlige rutiner',
        'ru': 'Безлимитные персональные программы',
        'pt': 'Rotinas personalizadas ilimitadas',
        'ja': 'カスタムルーティンを無制限に作成',
        'zh': '无限生成个性化训练计划',
        'vi': 'Tạo không giới hạn bài tập cá nhân hóa',
        'ar': 'إنشاء غير محدود لروتينات مخصصة',
        'th': 'สร้างรูทีนเฉพาะบุคคลได้ไม่จำกัด',
      });

  String premiumBullet3() => _t({
        'ko': '광고 없이 쾌적한 운동 환경',
        'en': 'Completely ad-free workout sessions',
        'es': 'Entrenamientos totalmente sin anuncios',
        'fr': 'Entraînements entièrement sans publicité',
        'de': 'Workouts komplett ohne Werbung',
        'it': 'Allenamenti completamente senza pubblicità',
        'nl': 'Volledig advertentievrije trainingen',
        'da': 'Træning helt uden annoncer',
        'nb': 'Trening helt uten annonser',
        'ru': 'Тренировки без рекламы',
        'pt': 'Treinos totalmente sem anúncios',
        'ja': '広告なしで快適にワークアウト',
        'zh': '完全无广告的训练体验',
        'vi': 'Tập luyện hoàn toàn không quảng cáo',
        'ar': 'جلسات تمرين خالية تمامًا من الإعلانات',
        'th': 'ออกกำลังกายแบบไม่มีโฆษณารบกวน',
      });

  String ctaStartPremium() => _t({
        'ko': 'Valcue Pro 시작하기',
        'en': 'Start Valcue Pro',
        'es': 'Empezar con Valcue Pro',
        'fr': 'Commencer Valcue Pro',
        'de': 'Valcue Pro starten',
        'it': 'Inizia Valcue Pro',
        'nl': 'Start Valcue Pro',
        'da': 'Start Valcue Pro',
        'nb': 'Start Valcue Pro',
        'ru': 'Начать с Valcue Pro',
        'pt': 'Começar com Valcue Pro',
        'ja': 'Valcue Proを始める',
        'zh': '开始使用 Valcue Pro',
        'vi': 'Bắt đầu Valcue Pro',
        'ar': 'ابدأ Valcue Pro',
        'th': 'เริ่มใช้ Valcue Pro',
      });

  String ctaSkipPremium() => _t({
        'ko': '무료 버전으로 계속하기',
        'en': 'Continue with Free Version',
        'es': 'Continuar con la versión gratuita',
        'fr': 'Continuer avec la version gratuite',
        'de': 'Mit der kostenlosen Version fortfahren',
        'it': 'Continua con la versione gratuita',
        'nl': 'Doorgaan met de gratis versie',
        'da': 'Fortsæt med gratisversionen',
        'nb': 'Fortsett med gratisversjonen',
        'ru': 'Продолжить с бесплатной версией',
        'pt': 'Continuar com a versão gratuita',
        'ja': '無料版で続ける',
        'zh': '继续使用免费版',
        'vi': 'Tiếp tục với bản miễn phí',
        'ar': 'المتابعة بالإصدار المجاني',
        'th': 'ใช้เวอร์ชันฟรีต่อ',
      });

  // ---- helpers ----
  String _numberedLabel(int n, Map<String, String> map) {
    return _t(map).replaceAll('{n}', _number(n));
  }

  String _number(num value) => NumberFormat.decimalPattern(
        SupportedAppLanguage.fromCode(code).locale.toLanguageTag(),
      ).format(value);

  String _t(Map<String, String> map) => map[code] ?? map['en'] ?? '';

  List<EmphasisTextSpan> _spans(
    Map<String, List<EmphasisTextSpan>> map,
  ) =>
      map[code] ?? map['en'] ?? const <EmphasisTextSpan>[];
}
