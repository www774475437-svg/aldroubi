import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings and saved news, kept on the phone.
class Store extends ChangeNotifier {
  Store._();
  static final i = Store._();

  SharedPreferences? _p;
  int themeMode = 0; // 0 like the phone, 1 light, 2 dark
  double fontScale = 1.0;
  bool blurSensitive = true;
  bool urgentAlerts = true;
  Set<String> mutedSections = {};
  List<String> saved = [];

  ThemeMode get mode => themeMode == 1 ? ThemeMode.light : themeMode == 2 ? ThemeMode.dark : ThemeMode.system;

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      _p = p;
      themeMode = p.getInt('themeMode') ?? 0;
      fontScale = p.getDouble('fontScale') ?? 1.0;
      blurSensitive = p.getBool('blurSensitive') ?? true;
      urgentAlerts = p.getBool('urgentAlerts') ?? true;
      mutedSections = (p.getStringList('mutedSections') ?? const []).toSet();
      saved = p.getStringList('saved') ?? [];
    } catch (_) {}
  }

  void setSettings({int? themeMode, double? fontScale, bool? blurSensitive, bool? urgentAlerts}) {
    if (themeMode != null) {
      this.themeMode = themeMode;
      _p?.setInt('themeMode', themeMode);
    }
    if (fontScale != null) {
      this.fontScale = fontScale;
      _p?.setDouble('fontScale', fontScale);
    }
    if (blurSensitive != null) {
      this.blurSensitive = blurSensitive;
      _p?.setBool('blurSensitive', blurSensitive);
    }
    if (urgentAlerts != null) {
      this.urgentAlerts = urgentAlerts;
      _p?.setBool('urgentAlerts', urgentAlerts);
    }
    notifyListeners();
  }

  bool sectionOn(String id) => !mutedSections.contains(id);

  void toggleSection(String id) {
    if (!mutedSections.remove(id)) mutedSections.add(id);
    _p?.setStringList('mutedSections', mutedSections.toList());
    notifyListeners();
  }

  bool isSaved(String id) => saved.contains(id);

  /// Returns true when the item is now saved.
  bool toggleSaved(String id) {
    final now = !saved.remove(id);
    if (now) saved.insert(0, id);
    _p?.setStringList('saved', saved);
    notifyListeners();
    return now;
  }
}
