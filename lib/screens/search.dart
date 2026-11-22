import 'package:flutter/material.dart';

import '../data.dart';
import '../ui.dart';
import 'widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctl = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = searchNews(_q);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextField(
            controller: _ctl,
            autofocus: true,
            onChanged: (v) => setState(() => _q = v),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'ابحث في الأخبار…',
              filled: true,
              fillColor: C.card(context),
              prefixIcon: Icon(Icons.search_rounded, color: C.muted(context)),
              suffixIcon: _q.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _ctl.clear();
                        setState(() => _q = '');
                      },
                    ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: C.line(context))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: C.line(context))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: C.gold(context))),
            ),
          ),
        ),
      ),
      body: _q.trim().isEmpty
          ? ListView(padding: const EdgeInsets.all(16), children: [
              Text('عمليات بحث مقترحة', style: TextStyle(fontWeight: FontWeight.w700, color: C.muted(context))),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final w in ['عدن', 'تعز', 'مأرب', 'مساعدات', 'الريال', 'أمطار'])
                  Pressable(
                    scale: 0.92,
                    onTap: () {
                      _ctl.text = w;
                      setState(() => _q = w);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: C.card(context), borderRadius: BorderRadius.circular(20), border: Border.all(color: C.line(context))),
                      child: Text(w, style: TextStyle(fontWeight: FontWeight.w700, color: C.ink(context))),
                    ),
                  ),
              ]),
            ])
          : results.isEmpty
              ? const EmptyNote(Icons.search_off_rounded, 'لا توجد نتائج')
              : ListView(padding: const EdgeInsets.only(top: 8, bottom: 30), children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(Ar.news(results.length), style: TextStyle(color: C.muted(context))),
                  ),
                  for (var i = 0; i < results.length; i++) NewsTile(results[i], index: i),
                ]),
    );
  }
}
