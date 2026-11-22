import 'package:flutter/material.dart';

import '../data.dart';
import '../store.dart';
import '../ui.dart';
import 'article.dart';

void openNews(BuildContext context, News n) => go(context, ArticleScreen(n));

/// A news row: small picture, title, section and time.
class NewsTile extends StatelessWidget {
  final News n;
  final int index;
  const NewsTile(this.n, {super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      index: index,
      child: SoftCard(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(10),
        onTap: () => openNews(context, n),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 108, height: 84, child: NewsImage(n, radius: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 6, runSpacing: 4, children: [
                if (n.urgent) const UrgentBadge(),
                Tag(n.sec.name),
              ]),
              const SizedBox(height: 6),
              Text(n.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, height: 1.4, color: C.ink(context))),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.schedule_rounded, size: 14, color: C.muted(context)),
                const SizedBox(width: 4),
                Text(Ar.ago(n.time), style: TextStyle(fontSize: 12.5, color: C.muted(context))),
                if (n.region.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Icon(Icons.place_outlined, size: 14, color: C.muted(context)),
                  const SizedBox(width: 2),
                  Flexible(child: Text(n.region, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, color: C.muted(context)))),
                ],
              ]),
            ]),
          ),
          _SaveButton(n),
        ]),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final News n;
  const _SaveButton(this.n);
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Store.i,
      builder: (context, _) {
        final on = Store.i.isSaved(n.id);
        return Pressable(
          scale: 0.8,
          onTap: () => toast(context, Store.i.toggleSaved(n.id) ? 'حُفظ الخبر' : 'أُزيل من المحفوظة'),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(on ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  key: ValueKey(on), size: 22, color: on ? C.gold(context) : C.muted(context)),
            ),
          ),
        );
      },
    );
  }
}

/// Simple list page of news (a section, a region, a reporter).
class NewsListScreen extends StatelessWidget {
  final String title;
  final List<News> items;
  final Widget? header;
  const NewsListScreen({super.key, required this.title, required this.items, this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.only(top: 6, bottom: 30), children: [
        if (header != null) header!,
        if (items.isEmpty) const EmptyNote(Icons.article_outlined, 'لا توجد أخبار هنا بعد'),
        for (var i = 0; i < items.length; i++) NewsTile(items[i], index: i),
      ]),
    );
  }
}
