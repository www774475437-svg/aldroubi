import 'package:flutter/material.dart';

import '../data.dart';
import '../store.dart';
import '../ui.dart';
import 'widgets.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final items = Store.i.saved.map(newsById).whereType<News>().toList();
          return ListView(padding: const EdgeInsets.only(top: 18, bottom: 110), children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Text('المحفوظة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: C.ink(context))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Text('الأخبار التي حفظتها تبقى هنا، وتقرؤها حتى بلا إنترنت.', style: TextStyle(fontSize: 13.5, color: C.muted(context))),
            ),
            if (items.isEmpty)
              const EmptyNote(Icons.bookmark_border_rounded, 'لم تحفظ أي خبر بعد.\nاضغط علامة الحفظ على أي خبر ليظهر هنا.')
            else
              for (var i = 0; i < items.length; i++) NewsTile(items[i], index: i),
          ]);
        },
      ),
    );
  }
}
