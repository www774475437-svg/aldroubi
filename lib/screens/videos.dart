import 'package:flutter/material.dart';

import '../data.dart';
import '../ui.dart';
import '../update.dart';
import 'widgets.dart';

/// Red dot that pulses, used for "live".
class LiveDot extends StatefulWidget {
  final double size;
  const LiveDot({super.key, this.size = 10});
  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s * 2.4,
      height: s * 2.4,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(alignment: Alignment.center, children: [
          Container(
            width: s + s * 1.4 * _c.value,
            height: s + s * 1.4 * _c.value,
            decoration: BoxDecoration(shape: BoxShape.circle, color: red.withValues(alpha: 0.5 * (1 - _c.value))),
          ),
          Container(width: s, height: s, decoration: const BoxDecoration(shape: BoxShape.circle, color: red)),
        ]),
      ),
    );
  }
}

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoNews = allNews.where((n) => n.video).toList();
    return SafeArea(
      bottom: false,
      child: ListView(padding: const EdgeInsets.only(top: 18, bottom: 110), children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Text('المرئيات', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: C.ink(context))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Pressable(
            scale: 0.98,
            onTap: () => go(context, const LiveScreen()),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [Color(0xFF111111), Color(0xFF3A3123)], begin: Alignment.topRight, end: Alignment.bottomLeft),
              ),
              child: Stack(children: [
                const Positioned(
                  top: 14,
                  right: 14,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    LiveDot(size: 9),
                    Text('مباشر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ]),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(color: beige, shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded, size: 40, color: black),
                  ),
                ),
                const Positioned(
                  bottom: 14,
                  right: 16,
                  left: 16,
                  child: Text('البث المباشر لقناة الدروبي', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
          ),
        ),
        const SectionTitle('مقاطع قصيرة'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: clips.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 9 / 15),
          itemBuilder: (context, i) => FadeSlide(
            index: i,
            child: Pressable(
              onTap: () => go(context, ShortsScreen(start: i)),
              child: _ClipCard(clips[i], i),
            ),
          ),
        ),
        if (videoNews.isNotEmpty) ...[
          const SectionTitle('تقارير مصوّرة'),
          for (var i = 0; i < videoNews.length; i++) NewsTile(videoNews[i], index: i),
        ],
      ]),
    );
  }
}

class _ClipCard extends StatelessWidget {
  final ShortClip c;
  final int i;
  const _ClipCard(this.c, this.i);
  @override
  Widget build(BuildContext context) {
    final s = sectionOf(c.section);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.lerp(s.color, Colors.black, 0.2)!, Color.lerp(s.color, const Color(0xFF8A7650), 0.4)!],
            begin: i.isEven ? Alignment.topRight : Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(children: [
          Positioned(left: -16, top: 30, child: Icon(s.icon, size: 110, color: Colors.white.withValues(alpha: 0.07))),
          const Center(child: Icon(Icons.play_circle_fill_rounded, size: 48, color: Colors.white70)),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
              child: Text(c.length, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          Positioned(
            right: 10,
            left: 10,
            bottom: 12,
            child: Text(c.title, maxLines: 2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5, height: 1.4)),
          ),
        ]),
      ),
    );
  }
}

/// Vertical clips you swipe up and down.
class ShortsScreen extends StatelessWidget {
  final int start;
  const ShortsScreen({super.key, this.start = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, foregroundColor: Colors.white),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: start),
        itemCount: clips.length,
        itemBuilder: (context, i) => Stack(fit: StackFit.expand, children: [
          _ClipCard(clips[i], i),
          Positioned(
            bottom: 40,
            right: 20,
            left: 20,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(clips[i].title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('سيُعرض المقطع الحقيقي هنا عند ربط التطبيق بالقناة', style: TextStyle(color: Colors.white70, fontSize: 13.5)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البث المباشر')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(20)),
            child: const Stack(children: [
              Positioned(top: 12, right: 12, child: Row(mainAxisSize: MainAxisSize.min, children: [LiveDot(size: 9), Text('مباشر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))])),
              Center(child: Icon(Icons.live_tv_rounded, color: beige, size: 56)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Text('قناة الدروبي — البث المباشر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: C.ink(context))),
        const SizedBox(height: 6),
        Text('تابع تغطية القناة المباشرة للأحداث لحظة بلحظة.', style: TextStyle(fontSize: 15, color: C.muted(context), height: 1.6)),
        const SizedBox(height: 18),
        Pressable(
          onTap: () => openOrSoon(context, liveUrl),
          child: Container(
            height: 54,
            decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(18)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white),
              SizedBox(width: 6),
              Text('شاهد البث على يوتيوب', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ]),
    );
  }
}
