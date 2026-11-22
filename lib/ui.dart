import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'data.dart';
import 'store.dart';

/// Colours of «قناة الدروبي»: black and white with the logo's gold/beige.
class C {
  static bool dark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
  static Color bg(BuildContext c) => dark(c) ? const Color(0xFF0B0B0B) : const Color(0xFFF6F5F2);
  static Color card(BuildContext c) => dark(c) ? const Color(0xFF171717) : Colors.white;
  static Color line(BuildContext c) => dark(c) ? const Color(0xFF2A2A2A) : const Color(0xFFE6E2DA);
  static Color ink(BuildContext c) => dark(c) ? const Color(0xFFF3F0EA) : const Color(0xFF111111);
  static Color muted(BuildContext c) => dark(c) ? const Color(0xFF9B978F) : const Color(0xFF77736B);
  static Color accent(BuildContext c) => dark(c) ? const Color(0xFFD9BE82) : const Color(0xFF111111);
  static Color gold(BuildContext c) => dark(c) ? const Color(0xFFD9BE82) : const Color(0xFFAE8B4C);
  static Color soft(BuildContext c) => dark(c) ? const Color(0xFF222222) : const Color(0xFFEFEBE3);
}

const black = Color(0xFF111111);
const gold = Color(0xFFAE8B4C);
const beige = Color(0xFFCFC3AC);
const red = Color(0xFFC62828);
const uiFont = 'Tajawal';

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final bg = dark ? const Color(0xFF0B0B0B) : const Color(0xFFF6F5F2);
  final ink = dark ? const Color(0xFFF3F0EA) : black;
  return ThemeData(
    brightness: b,
    useMaterial3: true,
    fontFamily: uiFont,
    scaffoldBackgroundColor: bg,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: b,
      surface: bg,
      primary: dark ? const Color(0xFFD9BE82) : black,
      secondary: gold,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: uiFont, fontSize: 20, fontWeight: FontWeight.w700, color: ink),
    ),
    textTheme: (dark ? Typography.material2021().white : Typography.material2021().black)
        .apply(fontFamily: uiFont, bodyColor: ink, displayColor: ink),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: black,
      contentTextStyle: TextStyle(fontFamily: uiFont, color: Colors.white, fontSize: 15),
    ),
  );
}

void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 2)));
}

/// Arabic-Indic digits and "time ago".
class Ar {
  static const _d = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  static String num(Object n) => n.toString().split('').map((c) {
        final i = c.codeUnitAt(0) - 48;
        return i >= 0 && i <= 9 ? _d[i] : c;
      }).join();

  static String ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'الآن';
    if (d.inMinutes < 60) {
      final m = d.inMinutes;
      if (m == 1) return 'قبل دقيقة';
      if (m == 2) return 'قبل دقيقتين';
      if (m <= 10) return 'قبل ${num(m)} دقائق';
      return 'قبل ${num(m)} دقيقة';
    }
    if (d.inHours < 24) {
      final h = d.inHours;
      if (h == 1) return 'قبل ساعة';
      if (h == 2) return 'قبل ساعتين';
      if (h <= 10) return 'قبل ${num(h)} ساعات';
      return 'قبل ${num(h)} ساعة';
    }
    final days = d.inDays;
    if (days == 1) return 'أمس';
    if (days == 2) return 'قبل يومين';
    if (days <= 10) return 'قبل ${num(days)} أيام';
    return 'قبل ${num(days)} يومًا';
  }

  static String count(int n, String one, String two, String few, String many) {
    if (n == 1) return one;
    if (n == 2) return two;
    if (n >= 3 && n <= 10) return '${num(n)} $few';
    return '${num(n)} $many';
  }

  static String news(int n) => count(n, 'خبر واحد', 'خبران', 'أخبار', 'خبرًا');
}

const _weekdays = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
const _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

String todayLine() {
  final d = DateTime.now();
  return '${_weekdays[d.weekday - 1]} ${Ar.num(d.day)} ${_months[d.month - 1]} ${Ar.num(d.year)}';
}

/// Shrinks a little when pressed: the app's simple tap animation.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  const Pressable({super.key, required this.child, this.onTap, this.onLongPress, this.scale = 0.96});
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;
  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _set(true),
      onTapUp: widget.onTap == null ? null : (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Fades and slides a widget in when it first appears.
class FadeSlide extends StatelessWidget {
  final Widget child;
  final int index;
  const FadeSlide({super.key, required this.child, this.index = 0});
  @override
  Widget build(BuildContext context) {
    final ms = 320 + index.clamp(0, 8).toInt() * 70;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: ms),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const SectionTitle(this.title, {super.key, this.onMore});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Row(children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: C.gold(context), borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: C.ink(context)))),
        if (onMore != null)
          Pressable(
            onTap: onMore,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('المزيد', style: TextStyle(fontSize: 15, color: C.gold(context), fontWeight: FontWeight.w700)),
                Icon(Icons.chevron_left_rounded, color: C.gold(context), size: 22),
              ]),
            ),
          ),
      ]),
    );
  }
}

/// A rounded card with a thin border.
class SoftCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  const SoftCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(14), this.margin = EdgeInsets.zero, this.color});
  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? C.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.line(context)),
      ),
      child: child,
    );
    return Padding(padding: margin, child: onTap == null ? card : Pressable(onTap: onTap, scale: 0.98, child: card));
  }
}

class Tag extends StatelessWidget {
  final String text;
  final Color? color;
  final bool filled;
  const Tag(this.text, {super.key, this.color, this.filled = false});
  @override
  Widget build(BuildContext context) {
    final c = color ?? C.gold(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: filled ? c : c.withValues(alpha: 0.13), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 12, color: filled ? Colors.white : c, fontWeight: FontWeight.w700)),
    );
  }
}

/// Small red "عاجل" label with a blinking dot.
class UrgentBadge extends StatefulWidget {
  final String text;
  const UrgentBadge({super.key, this.text = 'عاجل'});
  @override
  State<UrgentBadge> createState() => _UrgentBadgeState();
}

class _UrgentBadgeState extends State<UrgentBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        FadeTransition(
          opacity: Tween(begin: 0.25, end: 1.0).animate(_c),
          child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        ),
        const SizedBox(width: 5),
        Text(widget.text, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

/// The channel logo in a rounded white box.
class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 44});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.28),
          border: Border.all(color: C.line(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
      );
}

/// Placeholder picture of a news item (real photos come later),
/// blurred with a warning when it contains painful scenes.
class NewsImage extends StatelessWidget {
  final News n;
  final double radius;
  final bool big;
  final bool revealed;
  final int variant;
  const NewsImage(this.n, {super.key, this.radius = 18, this.big = false, this.revealed = false, this.variant = 0});

  @override
  Widget build(BuildContext context) {
    final s = n.sec;
    final base = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: variant.isEven ? Alignment.topRight : Alignment.topLeft,
          end: variant.isEven ? Alignment.bottomLeft : Alignment.bottomRight,
          colors: [Color.lerp(s.color, Colors.black, 0.15)!, Color.lerp(s.color, const Color(0xFF8A7650), 0.35)!],
        ),
      ),
      child: Stack(fit: StackFit.expand, children: [
        Positioned(
          left: -20,
          bottom: -24,
          child: Icon(s.icon, size: big ? 200 : 90, color: Colors.white.withValues(alpha: 0.07)),
        ),
        Center(child: Icon(n.video ? Icons.play_circle_fill_rounded : Icons.image_rounded, size: big ? 58 : 30, color: Colors.white.withValues(alpha: 0.55))),
      ]),
    );
    return ListenableBuilder(listenable: Store.i, builder: (context, _) {
      final hide = n.sensitive && Store.i.blurSensitive && !revealed;
      return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: !hide
          ? base
          : Stack(fit: StackFit.expand, children: [
              ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), child: base),
              Container(color: Colors.black.withValues(alpha: 0.45)),
              Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.visibility_off_rounded, color: Colors.white, size: big ? 34 : 22),
                  if (big) ...[
                    const SizedBox(height: 8),
                    const Text('تحتوي على مشاهد مؤلمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('اضغط للعرض', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ]),
              ),
            ]),
      );
    });
  }
}

class EmptyNote extends StatelessWidget {
  final IconData icon;
  final String text;
  const EmptyNote(this.icon, this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: Column(children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: C.soft(context), shape: BoxShape.circle),
          child: Icon(icon, size: 34, color: C.gold(context)),
        ),
        const SizedBox(height: 16),
        Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: C.muted(context), height: 1.6)),
      ]),
    );
  }
}

/// Opens a page with a gentle fade + slide.
Future<T?> go<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, a, __, child) {
      final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: c,
        child: SlideTransition(position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(c), child: child),
      );
    },
  ));
}
