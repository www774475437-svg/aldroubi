import 'package:flutter/material.dart';

import '../data.dart';
import '../ui.dart';

/// Full-screen photos: swipe between them and zoom with two fingers.
class GalleryScreen extends StatefulWidget {
  final News n;
  final int start;
  const GalleryScreen(this.n, {super.key, this.start = 0});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final _pc = PageController(initialPage: widget.start);
  late int _i = widget.start;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.n.photos;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${Ar.num(_i + 1)} من ${Ar.num(count)}', style: const TextStyle(color: Colors.white, fontSize: 17)),
      ),
      body: Column(children: [
        Expanded(
          child: PageView.builder(
            controller: _pc,
            itemCount: count,
            onPageChanged: (p) => setState(() => _i = p),
            itemBuilder: (context, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: NewsImage(widget.n, radius: 0, big: true, variant: i, revealed: true),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Text(widget.n.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
        ),
      ]),
    );
  }
}
