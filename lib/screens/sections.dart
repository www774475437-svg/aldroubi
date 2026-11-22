import 'package:flutter/material.dart';

import '../data.dart';
import '../ui.dart';
import 'widgets.dart';

class SectionsScreen extends StatelessWidget {
  const SectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 18, 16, 110), children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Text('الأقسام', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: C.ink(context))),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.35),
          itemBuilder: (context, i) {
            final s = sections[i];
            final count = inSection(s.id).length;
            return FadeSlide(
              index: i,
              child: Pressable(
                onTap: () => go(context, SectionScreen(s)),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [s.color, Color.lerp(s.color, const Color(0xFF8A7650), 0.4)!],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(left: -14, bottom: -14, child: Icon(s.icon, size: 80, color: Colors.white.withValues(alpha: 0.1))),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        child: Icon(s.icon, color: beige, size: 22),
                      ),
                      const Spacer(),
                      Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(Ar.news(count), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ]),
                  ]),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        _Wide(
          icon: Icons.map_rounded,
          title: 'الأحداث حسب المحافظات',
          sub: 'أخبار كل محافظة في مكان واحد',
          onTap: () => go(context, const RegionsScreen()),
        ),
        _Wide(
          icon: Icons.mic_external_on_rounded,
          title: 'مراسلو القناة',
          sub: 'أخبار كل مراسل من موقعه',
          onTap: () => go(context, const ReportersScreen()),
        ),
      ]),
    );
  }
}

class _Wide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const _Wide({required this.icon, required this.title, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => SoftCard(
        margin: const EdgeInsets.only(bottom: 10),
        onTap: onTap,
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: C.soft(context), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: C.gold(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: C.ink(context))),
              Text(sub, style: TextStyle(fontSize: 13, color: C.muted(context))),
            ]),
          ),
          Icon(Icons.chevron_left_rounded, color: C.muted(context)),
        ]),
      );
}

class SectionScreen extends StatelessWidget {
  final Section s;
  const SectionScreen(this.s, {super.key});
  @override
  Widget build(BuildContext context) => NewsListScreen(title: s.name, items: inSection(s.id));
}

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counts = {for (final r in regions) r: inRegion(r).length};
    final max = counts.values.fold<int>(1, (a, b) => b > a ? b : a);
    return Scaffold(
      appBar: AppBar(title: const Text('الأحداث حسب المحافظات')),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 6, 16, 30), children: [
        for (var i = 0; i < regions.length; i++)
          FadeSlide(
            index: i,
            child: SoftCard(
              margin: const EdgeInsets.only(bottom: 10),
              onTap: () => go(context, NewsListScreen(title: 'أخبار ${regions[i]}', items: inRegion(regions[i]))),
              child: Row(children: [
                Icon(Icons.place_rounded, color: C.gold(context)),
                const SizedBox(width: 10),
                SizedBox(width: 78, child: Text(regions[i], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.ink(context)))),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: counts[regions[i]]! / max),
                      duration: Duration(milliseconds: 600 + i * 60),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor: C.soft(context),
                        valueColor: AlwaysStoppedAnimation(C.gold(context)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(Ar.num(counts[regions[i]]!), style: TextStyle(fontWeight: FontWeight.w700, color: C.ink(context))),
              ]),
            ),
          ),
      ]),
    );
  }
}

class ReportersScreen extends StatelessWidget {
  const ReportersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراسلو القناة')),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 6, 16, 30), children: [
        for (var i = 0; i < reporters.length; i++)
          FadeSlide(
            index: i,
            child: SoftCard(
              margin: const EdgeInsets.only(bottom: 10),
              onTap: () => go(context, NewsListScreen(title: 'مراسل القناة في ${reporters[i]}', items: inRegion(reporters[i]))),
              child: Row(children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: black,
                    border: Border.all(color: beige, width: 1.5),
                  ),
                  child: const Icon(Icons.person_rounded, color: beige, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('مراسل القناة في ${reporters[i]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.ink(context))),
                    Text(Ar.news(inRegion(reporters[i]).length), style: TextStyle(fontSize: 13, color: C.muted(context))),
                  ]),
                ),
                Icon(Icons.chevron_left_rounded, color: C.muted(context)),
              ]),
            ),
          ),
      ]),
    );
  }
}
