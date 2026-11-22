import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';

import '../data.dart';
import '../store.dart';
import '../ui.dart';
import '../update.dart';
import 'gallery.dart';
import 'widgets.dart';

class ArticleScreen extends StatefulWidget {
  final News n;
  const ArticleScreen(this.n, {super.key});
  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _tts = FlutterTts();
  bool _speaking = false;
  bool _revealed = false;

  News get n => widget.n;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    try {
      if (_speaking) {
        await _tts.stop();
        if (mounted) setState(() => _speaking = false);
        return;
      }
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.45);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _speaking = false);
      });
      setState(() => _speaking = true);
      await _tts.speak('${n.title}. ${n.body.join(' ')}');
    } catch (_) {
      if (mounted) {
        setState(() => _speaking = false);
        toast(context, 'القراءة الصوتية غير متاحة على هذا الجهاز');
      }
    }
  }

  void _share() {
    Share.share('${n.title}\n\n${n.summary}\n\n— قناة الدروبي\n$siteUrl');
  }

  @override
  Widget build(BuildContext context) {
    final rel = related(n);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 280,
          backgroundColor: C.bg(context),
          leading: _Round(Icons.arrow_forward_rounded, () => Navigator.pop(context)),
          actions: [
            ListenableBuilder(
              listenable: Store.i,
              builder: (context, _) {
                final on = Store.i.isSaved(n.id);
                return _Round(on ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, () {
                  toast(context, Store.i.toggleSaved(n.id) ? 'حُفظ الخبر' : 'أُزيل من المحفوظة');
                }, color: on ? gold : null);
              },
            ),
            _Round(Icons.share_rounded, _share),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              onTap: () {
                if (n.sensitive && !_revealed && Store.i.blurSensitive) {
                  setState(() => _revealed = true);
                } else if (n.photos > 0) {
                  go(context, GalleryScreen(n));
                }
              },
              child: NewsImage(n, radius: 0, big: true, revealed: _revealed),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeSlide(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 6, runSpacing: 6, children: [
                  if (n.urgent) const UrgentBadge(),
                  Tag(n.sec.name),
                  if (n.video) Tag('فيديو', color: C.muted(context)),
                ]),
                const SizedBox(height: 12),
                Text(n.title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, height: 1.45, color: C.ink(context))),
                const SizedBox(height: 12),
                Row(children: [
                  CircleAvatar(radius: 16, backgroundColor: C.soft(context), child: Icon(Icons.mic_rounded, size: 17, color: C.gold(context))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(n.reporter, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.ink(context))),
                      Text('${Ar.ago(n.time)} · ${Ar.num(n.views)} مشاهدة', style: TextStyle(fontSize: 12.5, color: C.muted(context))),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  _Pill(_speaking ? Icons.stop_rounded : Icons.volume_up_rounded, _speaking ? 'إيقاف' : 'استمع للخبر', _toggleSpeak, active: _speaking),
                  const SizedBox(width: 8),
                  _Pill(Icons.share_rounded, 'مشاركة', _share),
                ]),
                const SizedBox(height: 8),
                Divider(color: C.line(context), height: 26),
                for (final p in n.body)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(p, style: TextStyle(fontSize: 17.5, height: 1.95, color: C.ink(context))),
                  ),
              ]),
            ),
          ),
        ),
        if (n.photos > 0)
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionTitle('الصور (${Ar.num(n.photos)})'),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: n.photos,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => Pressable(
                    scale: 0.94,
                    onTap: () => go(context, GalleryScreen(n, start: i)),
                    child: SizedBox(width: 140, child: NewsImage(n, radius: 14, variant: i, revealed: _revealed)),
                  ),
                ),
              ),
            ]),
          ),
        if (rel.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SectionTitle('أخبار ذات صلة')),
          SliverList.builder(itemCount: rel.length, itemBuilder: (context, i) => NewsTile(rel[i], index: i)),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ]),
    );
  }
}

class _Round extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _Round(this.icon, this.onTap, {this.color});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(6),
        child: Pressable(
          scale: 0.85,
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
            child: Icon(icon, color: color ?? Colors.white, size: 22),
          ),
        ),
      );
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool active;
  const _Pill(this.icon, this.text, this.onTap, {this.active = false});
  @override
  Widget build(BuildContext context) => Pressable(
        scale: 0.93,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: active ? C.gold(context) : C.card(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: active ? C.gold(context) : C.line(context)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 19, color: active ? Colors.white : C.ink(context)),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: active ? Colors.white : C.ink(context))),
          ]),
        ),
      );
}
