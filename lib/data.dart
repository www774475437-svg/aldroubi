import 'package:flutter/material.dart';

/// A news section (قسم).
class Section {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  const Section(this.id, this.name, this.icon, this.color);
}

const sections = [
  Section('yemen', 'أخبار اليمن', Icons.flag_rounded, Color(0xFF2B2B2B)),
  Section('field', 'الميدان', Icons.shield_rounded, Color(0xFF5B4A2C)),
  Section('politics', 'السياسة', Icons.account_balance_rounded, Color(0xFF2E3A48)),
  Section('economy', 'الاقتصاد', Icons.trending_up_rounded, Color(0xFF2E4A3A)),
  Section('humanitarian', 'الإنسانية', Icons.volunteer_activism_rounded, Color(0xFF4C2F35)),
  Section('world', 'العالم', Icons.public_rounded, Color(0xFF35304A)),
  Section('reports', 'تقارير', Icons.article_rounded, Color(0xFF3B3B3B)),
];

Section sectionOf(String id) => sections.firstWhere((s) => s.id == id, orElse: () => sections.first);

const regions = ['صنعاء', 'عدن', 'تعز', 'مأرب', 'الحديدة', 'حضرموت', 'إب', 'الضالع', 'شبوة', 'صعدة'];

final _start = DateTime.now();

/// One news item. The current items are samples until the channel's real news is connected.
class News {
  final String id;
  final String title;
  final String summary;
  final String section;
  final String region;
  final int minutesAgo;
  final bool urgent;
  final bool sensitive;
  final int photos;
  final bool video;
  final int views;
  const News(this.id, this.title, this.summary, this.section,
      {this.region = '', this.minutesAgo = 30, this.urgent = false, this.sensitive = false, this.photos = 0, this.video = false, this.views = 0});

  Section get sec => sectionOf(section);
  DateTime get time => _start.subtract(Duration(minutes: minutesAgo));
  String get reporter => region.isEmpty ? 'غرفة الأخبار' : 'مراسل القناة في $region';

  List<String> get body => [
        summary,
        'هذا نصّ تجريبي يوضّح شكل الخبر داخل التطبيق: العنوان، ثم المقدّمة، ثم التفاصيل في فقرات مرتّبة سهلة القراءة، مع اسم المراسل ووقت النشر.',
        'وعند ربط التطبيق بالقناة ستظهر هنا الأخبار الحقيقية بنصوصها وصورها ومقاطعها، وتصل الأخبار العاجلة إلى الجوال فور نشرها.',
        'ويستطيع القارئ حفظ الخبر للرجوع إليه، أو مشاركته على واتساب وتيليجرام، أو الاستماع إليه بصوت مسموع، وتكبير الخط أو تصغيره من الإعدادات.',
      ];
}

const allNews = [
  News('n1', 'انقطاع واسع للتيار الكهربائي في عدد من أحياء مدينة عدن',
      'شهدت عدة أحياء في مدينة عدن انقطاعًا واسعًا للتيار الكهربائي منذ ساعات الصباح، وسط مطالبات من السكان بسرعة إعادة الخدمة.', 'yemen',
      region: 'عدن', minutesAgo: 6, urgent: true, photos: 3, views: 5400),
  News('n2', 'وصول قافلة مساعدات غذائية إلى مديريات في محافظة تعز',
      'وصلت قافلة محمّلة بالمساعدات الغذائية إلى عدد من المديريات في تعز، لتوزيعها على الأسر الأشد احتياجًا.', 'humanitarian',
      region: 'تعز', minutesAgo: 18, urgent: true, photos: 5, views: 4100),
  News('n3', 'تقرير ميداني: آثار القصف على المنازل في إحدى قرى الضالع',
      'رصد مراسل القناة حجم الأضرار التي لحقت بعدد من المنازل في إحدى قرى الضالع، والأوضاع التي يعيشها الأهالي.', 'field',
      region: 'الضالع', minutesAgo: 35, sensitive: true, photos: 6, views: 6800),
  News('n4', 'تحسّن طفيف في سعر صرف الريال اليمني في تعاملات اليوم',
      'سجّل الريال اليمني تحسّنًا طفيفًا أمام العملات الأجنبية في تعاملات اليوم، بحسب ما أفاد به عاملون في محلات الصرافة.', 'economy',
      region: 'عدن', minutesAgo: 52, views: 3900),
  News('n5', 'مشاورات سياسية جديدة بشأن الملف اليمني في عاصمة إقليمية',
      'انطلقت جولة جديدة من المشاورات السياسية المتعلقة بالملف اليمني، بمشاركة عدد من الأطراف والوسطاء.', 'politics',
      minutesAgo: 75, photos: 2, views: 2700),
  News('n6', 'منظمات إغاثية تحذّر من تفاقم سوء التغذية بين الأطفال',
      'حذّرت منظمات إغاثية من ارتفاع حالات سوء التغذية بين الأطفال في عدد من المناطق، ودعت إلى زيادة الدعم الإنساني.', 'humanitarian',
      region: 'الحديدة', minutesAgo: 110, photos: 4, views: 5100),
  News('n7', 'إعادة افتتاح طريق رئيسي بين محافظتين بعد أشهر من الإغلاق',
      'أُعيد افتتاح طريق رئيسي يربط بين محافظتين بعد أشهر من الإغلاق، ما يخفّف معاناة المسافرين وينشّط الحركة التجارية.', 'yemen',
      region: 'تعز', minutesAgo: 140, photos: 3, views: 3300),
  News('n8', 'بالفيديو: يوم في حياة صيّاد على سواحل حضرموت',
      'تقرير مصوّر يرافق أحد الصيادين في رحلته اليومية على سواحل حضرموت، ويعرض تحديات المهنة ومصادر الرزق.', 'reports',
      region: 'حضرموت', minutesAgo: 190, video: true, views: 2200),
  News('n9', 'ارتفاع أسعار الوقود في الأسواق المحلية وشكاوى من المواطنين',
      'شهدت الأسواق المحلية ارتفاعًا في أسعار الوقود، واشتكى مواطنون من انعكاس ذلك على أسعار النقل والسلع.', 'economy',
      region: 'صنعاء', minutesAgo: 230, views: 2900),
  News('n10', 'نزوح عشرات الأسر من مناطق التماس في مأرب',
      'نزحت عشرات الأسر من مناطق التماس في مأرب نحو مخيمات النزوح، في ظل ظروف معيشية صعبة.', 'field',
      region: 'مأرب', minutesAgo: 300, photos: 4, views: 4600),
  News('n11', 'أمطار غزيرة وسيول في محافظة إب وتحذيرات للمواطنين',
      'هطلت أمطار غزيرة على مناطق واسعة من محافظة إب، وحذّرت الجهات المختصة من الاقتراب من مجاري السيول.', 'yemen',
      region: 'إب', minutesAgo: 360, photos: 3, views: 3100),
  News('n12', 'مجلس الأمن يعقد جلسة لمناقشة الأوضاع الإنسانية في المنطقة',
      'عقد مجلس الأمن جلسة لمناقشة الأوضاع الإنسانية في المنطقة، واستمع إلى إحاطات من مسؤولين أمميين.', 'world',
      minutesAgo: 420, views: 1900),
  News('n13', 'مشاهد من موقع انفجار في محافظة شبوة',
      'نقل مراسل القناة مشاهد من موقع انفجار في محافظة شبوة، فيما تواصل الجهات المختصة التحقيق في ملابساته.', 'field',
      region: 'شبوة', minutesAgo: 500, sensitive: true, photos: 5, video: true, views: 7200),
  News('n14', 'تقرير: التعليم في اليمن بين الصعوبات والأمل',
      'يستعرض هذا التقرير واقع التعليم في عدد من المحافظات، والصعوبات التي يواجهها الطلاب والمعلمون.', 'reports',
      region: 'صعدة', minutesAgo: 640, photos: 4, views: 1800),
  News('n15', 'ارتفاع أسعار القمح عالميًا وتأثيره على الدول المستوردة',
      'ارتفعت أسعار القمح في الأسواق العالمية، ما يثير مخاوف الدول المعتمدة على الاستيراد من موجة غلاء جديدة.', 'world',
      minutesAgo: 900, views: 1500),
];

News? newsById(String id) {
  for (final n in allNews) {
    if (n.id == id) return n;
  }
  return null;
}

List<News> get urgentNews => allNews.where((n) => n.urgent).toList();
List<News> get topNews => allNews.where((n) => n.photos > 0 || n.video).take(5).toList();
List<News> get mostRead => [...allNews]..sort((a, b) => b.views.compareTo(a.views));
List<News> inSection(String id) => allNews.where((n) => n.section == id).toList();
List<News> inRegion(String r) => allNews.where((n) => n.region == r).toList();

List<News> related(News n) {
  final same = allNews.where((x) => x.id != n.id && (x.section == n.section || (n.region.isNotEmpty && x.region == n.region))).toList();
  return same.take(4).toList();
}

String _norm(String s) => s
    .replaceAll(RegExp('[ً-ْـ]'), '')
    .replaceAll(RegExp('[أإآ]'), 'ا')
    .replaceAll('ة', 'ه')
    .replaceAll('ى', 'ي');

List<News> searchNews(String q) {
  final k = _norm(q.trim());
  if (k.isEmpty) return const [];
  return allNews.where((n) => _norm('${n.title} ${n.summary} ${n.region} ${n.sec.name}').contains(k)).toList();
}

/// Short vertical clips (samples).
class ShortClip {
  final String title;
  final String length;
  final String section;
  const ShortClip(this.title, this.length, this.section);
}

const clips = [
  ShortClip('لقطات من سوق تعز القديم', '٠:٤٥', 'reports'),
  ShortClip('توزيع المساعدات على الأسر النازحة', '١:١٠', 'humanitarian'),
  ShortClip('أمطار وسيول في إب', '٠:٣٢', 'yemen'),
  ShortClip('جولة في ميناء عدن', '٠:٥٨', 'economy'),
  ShortClip('من مخيمات النزوح في مأرب', '١:٢٤', 'field'),
  ShortClip('سواحل حضرموت عند الغروب', '٠:٤٠', 'reports'),
];

/// The channel's reporters (samples by region).
const reporters = ['صنعاء', 'عدن', 'تعز', 'مأرب', 'الحديدة', 'حضرموت'];
