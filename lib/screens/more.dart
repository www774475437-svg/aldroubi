import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../data.dart';
import '../store.dart';
import '../ui.dart';
import '../update.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final st = Store.i;
          return ListView(padding: const EdgeInsets.fromLTRB(16, 18, 16, 110), children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
              child: Text('المزيد', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: C.ink(context))),
            ),
            SoftCard(
              onTap: () => go(context, const AboutScreen()),
              child: Row(children: [
                const Logo(size: 64),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('قناة الدروبي', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: C.ink(context))),
                    const SizedBox(height: 2),
                    Text('من نحن، ورسالة القناة، وطرق التواصل', style: TextStyle(fontSize: 13.5, color: C.muted(context))),
                  ]),
                ),
                Icon(Icons.chevron_left_rounded, color: C.muted(context)),
              ]),
            ),
            const _Head('تابعنا'),
            SizedBox(
              height: 92,
              child: Row(children: [
                for (final s in socials)
                  Expanded(
                    child: Pressable(
                      scale: 0.88,
                      onTap: () => openOrSoon(context, s.url),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                          child: Icon(s.icon, color: Colors.white, size: 25),
                        ),
                        const SizedBox(height: 6),
                        Text(s.name, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: C.ink(context))),
                      ]),
                    ),
                  ),
              ]),
            ),
            const _Head('المظهر'),
            _Group(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, icon: Icon(Icons.brightness_auto_rounded), label: Text('كالجوال')),
                    ButtonSegment(value: 1, icon: Icon(Icons.light_mode_rounded), label: Text('نهاري')),
                    ButtonSegment(value: 2, icon: Icon(Icons.dark_mode_rounded), label: Text('ليلي')),
                  ],
                  selected: {st.themeMode},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => st.setSettings(themeMode: s.first),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Row(children: [
                  const _Ico(Icons.format_size_rounded),
                  const SizedBox(width: 14),
                  Text('حجم الخط', style: TextStyle(fontWeight: FontWeight.w700, color: C.ink(context))),
                  const Spacer(),
                  Text('${Ar.num((st.fontScale * 100).round())}٪', style: TextStyle(color: C.muted(context))),
                ]),
              ),
              Slider(
                value: st.fontScale,
                min: 0.9,
                max: 1.25,
                divisions: 7,
                activeColor: C.gold(context),
                onChanged: (v) => st.setSettings(fontScale: v),
              ),
            ]),
            const _Head('القراءة'),
            _Group(children: [
              SwitchListTile(
                secondary: const _Ico(Icons.blur_on_rounded),
                title: const Text('تمويه الصور المؤلمة', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('تظهر الصور الدموية مموّهة حتى تضغط عليها'),
                value: st.blurSensitive,
                onChanged: (v) => st.setSettings(blurSensitive: v),
              ),
            ]),
            const _Head('التنبيهات'),
            _Group(children: [
              SwitchListTile(
                secondary: const _Ico(Icons.notifications_active_rounded),
                title: const Text('تنبيهات الأخبار العاجلة', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('يصلك الخبر العاجل فور نشره'),
                value: st.urgentAlerts,
                onChanged: (v) => st.setSettings(urgentAlerts: v),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('اختر الأقسام التي تصلك تنبيهاتها:', style: TextStyle(fontSize: 13.5, color: C.muted(context))),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final s in sections)
                      FilterChip(
                        label: Text(s.name),
                        avatar: Icon(s.icon, size: 17),
                        selected: st.sectionOn(s.id),
                        showCheckmark: false,
                        selectedColor: C.gold(context).withValues(alpha: 0.22),
                        onSelected: st.urgentAlerts ? (_) => st.toggleSection(s.id) : null,
                      ),
                  ]),
                ]),
              ),
            ]),
            const _Head('التطبيق'),
            _Group(children: [
              _Row(
                icon: Icons.share_rounded,
                title: 'شارك التطبيق',
                sub: 'أرسله لأصدقائك',
                onTap: () => Share.share('تطبيق قناة الدروبي — أخبار اليمن والعالم لحظة بلحظة\n${kIsWeb ? siteUrl : apkUrl}'),
              ),
              _Row(icon: Icons.star_rate_rounded, title: 'قيّم التطبيق', sub: 'رأيك يساعدنا على التحسين', onTap: () => openOrSoon(context, '')),
              if (kIsWeb)
                _Row(icon: Icons.android_rounded, title: 'تطبيق أندرويد', sub: 'حمّل التطبيق على جوالك', onTap: () => openLink(apkUrl))
              else
                _Row(icon: Icons.public_rounded, title: 'موقع القناة', sub: 'افتح الأخبار في المتصفح', onTap: () => openLink(siteUrl)),
              _Row(icon: Icons.privacy_tip_rounded, title: 'سياسة الخصوصية', onTap: () => openLink(privacyUrl)),
              _Row(icon: Icons.info_rounded, title: 'إصدار التطبيق', sub: 'نسخة ${Ar.num(appBuild)}'),
            ]),
            const _Head('المطوّر'),
            _Group(children: [
              _Row(icon: Icons.code_rounded, title: developerName, sub: 'تواصل مع المطوّر على تيليجرام', onTap: () => openLink(developerUrl)),
            ]),
          ]);
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('من نحن')),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 40), children: [
        FadeSlide(
          child: Container(
            height: 230,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: C.line(context))),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 20),
        Text('قناة الدروبي', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: C.ink(context))),
        const SizedBox(height: 4),
        Text('معركة تحرير اليمن', style: TextStyle(fontSize: 15, color: C.gold(context), fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        Text(
          'منصة إخبارية تنقل أخبار اليمن والعالم لحظة بلحظة: الأخبار العاجلة، والتقارير الميدانية، والأوضاع الإنسانية والاقتصادية، '
          'بالصورة والفيديو والبث المباشر، عبر مراسلي القناة في المحافظات.',
          style: TextStyle(fontSize: 16, height: 1.9, color: C.ink(context)),
        ),
        const SizedBox(height: 22),
        Text('تواصل معنا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.ink(context))),
        const SizedBox(height: 10),
        for (final s in socials)
          SoftCard(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: () => openOrSoon(context, s.url),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                child: Icon(s.icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(s.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.ink(context)))),
              Icon(Icons.chevron_left_rounded, color: C.muted(context)),
            ]),
          ),
      ]),
    );
  }
}

class _Head extends StatelessWidget {
  final String title;
  const _Head(this.title);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
        child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.muted(context))),
      );
}

class _Group extends StatelessWidget {
  final List<Widget> children;
  const _Group({required this.children});
  @override
  Widget build(BuildContext context) => Material(
        color: C.card(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: C.line(context))),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      );
}

class _Ico extends StatelessWidget {
  final IconData icon;
  const _Ico(this.icon);
  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: C.gold(context).withValues(alpha: 0.14), borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, size: 20, color: C.gold(context)),
      );
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? sub;
  final VoidCallback? onTap;
  const _Row({required this.icon, required this.title, this.sub, this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
        leading: _Ico(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: sub == null ? null : Text(sub!),
        trailing: onTap == null ? null : Icon(Icons.chevron_left_rounded, color: C.muted(context)),
        onTap: onTap,
      );
}
