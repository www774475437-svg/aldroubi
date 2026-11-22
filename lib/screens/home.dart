import 'dart:async';

import 'package:flutter/material.dart';

import '../data.dart';
import '../ui.dart';
import '../update.dart';
import 'search.dart';
import 'sections.dart';
import 'videos.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final latest = allNews.take(8).toList();
    final most = mostRead.take(5).toList();
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: C.gold(context),
        onRefresh: () => Future.delayed(const Duration(milliseconds: 700)),
        child: ListView(padding: const EdgeInsets.only(bottom: 110), children: [
          const _Header(),
          const _UpdateBanner(),
          const _BreakingBar(),
          const SizedBox(height: 14),
          const _Headlines(),
          const _SectionChips(),
          const _SampleNote(),
          SectionTitle('آخر الأخبار', onMore: () => go(context, NewsListScreen(title: 'كل الأخبار', items: allNews))),
          for (var i = 0; i < latest.length; i++) NewsTile(latest[i], index: i),
          const _LiveCard(),
          const SectionTitle('الأكثر قراءة'),
          for (var i = 0; i < most.length; i++) _MostReadRow(most[i], i + 1),
        ]),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(children: [
        const Logo(size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('قناة الدروبي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.ink(context))),
            Text(todayLine(), style: TextStyle(fontSize: 13, color: C.muted(context))),
          ]),
        ),
        _CircleButton(Icons.search_rounded, () => go(context, const SearchScreen())),
      ]),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Pressable(
        scale: 0.88,
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: C.card(context), shape: BoxShape.circle, border: Border.all(color: C.line(context))),
          child: Icon(icon, color: C.ink(context)),
        ),
      );
}

class _UpdateBanner extends StatelessWidget {
  const _UpdateBanner();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Updates.newer,
      builder: (context, n, _) => n == 0
          ? const SizedBox.shrink()
          : SoftCard(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              color: C.gold(context).withValues(alpha: 0.14),
              onTap: () => openLink(apkUrl),
              child: Row(children: [
                Icon(Icons.system_update_rounded, color: C.gold(context)),
                const SizedBox(width: 10),
                Expanded(child: Text('نسخة جديدة من التطبيق متاحة، اضغط للتحميل', style: TextStyle(fontWeight: FontWeight.w700, color: C.ink(context)))),
              ]),
            ),
    );
  }
}

/// Red "عاجل" bar with the urgent headlines moving across.
class _BreakingBar extends StatelessWidget {
  const _BreakingBar();
  @override
  Widget build(BuildContext context) {
    final items = urgentNews;
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Pressable(
        scale: 0.98,
        onTap: () => openNews(context, items.first),
        child: Container(
          height: 44,
          decoration: BoxDecoration(color: C.card(context), borderRadius: BorderRadius.circular(14), border: Border.all(color: red.withValues(alpha: 0.35))),
          clipBehavior: Clip.antiAlias,
          child: Row(children: [
            Container(
              color: red,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                SizedBox(width: 3),
                Text('عاجل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              ]),
            ),
            Expanded(child: Ticker(items.map((n) => n.title).join('   ●   '))),
          ]),
        ),
      ),
    );
  }
}

/// Text that keeps sliding across, like a TV news ticker.
class Ticker extends StatefulWidget {
  final String text;
  const Ticker(this.text, {super.key});
  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: Duration(milliseconds: 4000 + widget.text.length * 110))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontFamily: uiFont, fontSize: 14.5, fontWeight: FontWeight.w700, color: C.ink(context));
    return LayoutBuilder(builder: (context, box) {
      final tp = TextPainter(
        text: TextSpan(text: widget.text, style: style),
        textDirection: TextDirection.rtl,
        maxLines: 1,
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final tw = tp.width;
      final w = box.maxWidth;
      return ClipRect(
        child: SizedBox(
          width: w,
          height: box.maxHeight,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Stack(clipBehavior: Clip.none, children: [
              Positioned(
                left: -tw + (w + tw) * _c.value,
                top: 0,
                bottom: 0,
                child: Center(child: Text(widget.text, style: style, maxLines: 1, softWrap: false)),
              ),
            ]),
          ),
        ),
      );
    });
  }
}

/// Big headline cards that move by themselves and by swiping.
class _Headlines extends StatefulWidget {
  const _Headlines();
  @override
  State<_Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<_Headlines> {
  final _pc = PageController(viewportFraction: 0.9);
  final items = topNews;
  int _page = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pc.hasClients || items.isEmpty) return;
      _pc.animateToPage((_page + 1) % items.length, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 236,
        child: PageView.builder(
          controller: _pc,
          itemCount: items.length,
          onPageChanged: (p) => setState(() => _page = p),
          itemBuilder: (context, i) {
            final n = items[i];
            return AnimatedBuilder(
              animation: _pc,
              builder: (context, child) {
                var d = 0.0;
                if (_pc.hasClients && _pc.position.haveDimensions) d = ((_pc.page ?? 0) - i).abs().clamp(0.0, 1.0).toDouble();
                return Transform.scale(scale: 1 - d * 0.06, child: child);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Pressable(
                  scale: 0.98,
                  onTap: () => openNews(context, n),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(fit: StackFit.expand, children: [
                      NewsImage(n, radius: 0, big: true, variant: i),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xDD000000)],
                            stops: [0.35, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        left: 16,
                        bottom: 16,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            if (n.urgent) ...[const UrgentBadge(), const SizedBox(width: 6)],
                            Tag(n.sec.name, color: beige),
                            const Spacer(),
                            Text(Ar.ago(n.time), style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                          ]),
                          const SizedBox(height: 8),
                          Text(n.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.4)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < items.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _page == i ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: _page == i ? C.gold(context) : C.line(context),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
      ]),
    ]);
  }
}

class _SectionChips extends StatelessWidget {
  const _SectionChips();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final s = sections[i];
          return Pressable(
            scale: 0.92,
            onTap: () => go(context, SectionScreen(s)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: C.card(context), borderRadius: BorderRadius.circular(22), border: Border.all(color: C.line(context))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(s.icon, size: 18, color: C.gold(context)),
                const SizedBox(width: 6),
                Text(s.name, style: TextStyle(fontWeight: FontWeight.w700, color: C.ink(context))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _SampleNote extends StatelessWidget {
  const _SampleNote();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(children: [
          Icon(Icons.info_outline_rounded, size: 16, color: C.muted(context)),
          const SizedBox(width: 6),
          Expanded(
            child: Text('الأخبار الحالية نماذج لعرض شكل التطبيق، وستُستبدل بأخبار القناة.',
                style: TextStyle(fontSize: 12.5, color: C.muted(context))),
          ),
        ]),
      );
}

/// "Live now" card with a pulsing red dot.
class _LiveCard extends StatelessWidget {
  const _LiveCard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Pressable(
        scale: 0.98,
        onTap: () => go(context, const LiveScreen()),
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(colors: [Color(0xFF111111), Color(0xFF3A3123)], begin: Alignment.centerRight, end: Alignment.centerLeft),
          ),
          child: Row(children: [
            const LiveDot(size: 14),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('البث المباشر', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('تابع القناة مباشرة', style: TextStyle(color: beige, fontSize: 13.5)),
              ]),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(color: beige, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: black, size: 30),
            ),
          ]),
        ),
      ),
    );
  }
}

class _MostReadRow extends StatelessWidget {
  final News n;
  final int rank;
  const _MostReadRow(this.n, this.rank);
  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      index: rank,
      child: Pressable(
        scale: 0.98,
        onTap: () => openNews(context, n),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 40,
              child: Text(Ar.num(rank),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: C.gold(context).withValues(alpha: 0.75), height: 1.1)),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, height: 1.45, color: C.ink(context))),
                const SizedBox(height: 4),
                Text('${n.sec.name} · ${Ar.ago(n.time)}', style: TextStyle(fontSize: 12.5, color: C.muted(context))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
