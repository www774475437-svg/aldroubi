import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home.dart';
import 'screens/more.dart';
import 'screens/saved.dart';
import 'screens/sections.dart';
import 'screens/splash.dart';
import 'screens/videos.dart';
import 'store.dart';
import 'ui.dart';
import 'update.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.i.load();
  runApp(const AldroubiApp());
  Updates.check();
}

final shellTab = ValueNotifier<int>(0);

class AldroubiApp extends StatelessWidget {
  const AldroubiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Store.i,
      builder: (context, _) => MaterialApp(
        title: 'قناة الدروبي',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: Store.i.mode,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(Store.i.fontScale)),
          child: child!,
        ),
        home: const SplashScreen(next: Shell()),
      ),
    );
  }
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'الرئيسية'),
    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'الأقسام'),
    (Icons.play_circle_outline_rounded, Icons.play_circle_rounded, 'المرئيات'),
    (Icons.bookmark_border_rounded, Icons.bookmark_rounded, 'المحفوظة'),
    (Icons.menu_rounded, Icons.menu_open_rounded, 'المزيد'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shellTab,
      builder: (context, tab, _) => PopScope(
        canPop: tab == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) shellTab.value = 0;
        },
        child: Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: tab,
            children: const [HomeScreen(), SectionsScreen(), VideosScreen(), SavedScreen(), MoreScreen()],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: C.card(context),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: C.line(context)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: C.dark(context) ? 0.5 : 0.1), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              child: Row(children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: Pressable(
                      scale: 0.9,
                      onTap: () => shellTab.value = i,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: EdgeInsets.symmetric(horizontal: tab == i ? 16 : 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tab == i ? (C.dark(context) ? C.gold(context) : black) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            tab == i ? _tabs[i].$2 : _tabs[i].$1,
                            color: tab == i ? (C.dark(context) ? black : Colors.white) : C.muted(context),
                            size: 23,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontFamily: uiFont,
                            fontSize: 11.5,
                            fontWeight: tab == i ? FontWeight.w700 : FontWeight.w500,
                            color: tab == i ? C.ink(context) : C.muted(context),
                          ),
                          child: Text(_tabs[i].$3, maxLines: 1),
                        ),
                      ]),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
