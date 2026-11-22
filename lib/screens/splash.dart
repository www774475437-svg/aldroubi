import 'package:flutter/material.dart';

import '../ui.dart';

/// Opening screen: the channel logo appears, then a gold line grows under it.
class SplashScreen extends StatefulWidget {
  final Widget next;
  const SplashScreen({super.key, required this.next});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2100));

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => widget.next,
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      ));
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoIn = CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack));
    final fade = CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.35, curve: Curves.easeOut));
    final line = CurvedAnimation(parent: _c, curve: const Interval(0.45, 0.8, curve: Curves.easeOutCubic));
    final text = CurvedAnimation(parent: _c, curve: const Interval(0.6, 0.95, curve: Curves.easeOut));
    final w = MediaQuery.of(context).size.width;
    final logo = (w * 0.78).clamp(200.0, 420.0).toDouble();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Column(mainAxisSize: MainAxisSize.min, children: [
            Opacity(
              opacity: fade.value,
              child: Transform.scale(
                scale: 0.82 + 0.18 * logoIn.value,
                child: Image.asset('assets/images/logo.png', width: logo, height: logo),
              ),
            ),
            Container(
              width: 140 * line.value,
              height: 3,
              decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 14),
            Opacity(
              opacity: text.value,
              child: const Text('أخبار اليمن والعالم لحظة بلحظة',
                  style: TextStyle(fontFamily: uiFont, fontSize: 16, color: Color(0xFF444444), fontWeight: FontWeight.w500)),
            ),
          ]),
        ),
      ),
    );
  }
}
