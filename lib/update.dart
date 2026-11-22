import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'ui.dart';

const appBuild = int.fromEnvironment('BUILD', defaultValue: 0);
const repo = 'www774475437-svg/aldroubi';
const siteUrl = 'https://www774475437-svg.github.io/aldroubi/';
const privacyUrl = '${siteUrl}privacy.html';
const apkUrl = 'https://github.com/$repo/releases/latest/download/aldroubi.apk';
const developerName = 'أبو عبد الرحمن الأثري';
const developerUrl = 'https://t.me/alhsaar4';

/// The channel's accounts. Empty ones are added when the owner sends them.
class Social {
  final String name;
  final IconData icon;
  final Color color;
  final String url;
  const Social(this.name, this.icon, this.color, this.url);
}

const socials = [
  Social('تيليجرام', Icons.send_rounded, Color(0xFF229ED9), ''),
  Social('واتساب', Icons.chat_rounded, Color(0xFF25D366), ''),
  Social('فيسبوك', Icons.facebook_rounded, Color(0xFF1877F2), ''),
  Social('يوتيوب', Icons.smart_display_rounded, Color(0xFFE53935), ''),
  Social('إكس', Icons.alternate_email_rounded, Color(0xFF111111), ''),
];

/// Live stream link (YouTube), added later.
const liveUrl = '';

Future<void> openLink(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
}

/// Opens the link, or says it will be added soon when it is still empty.
void openOrSoon(BuildContext context, String url) {
  if (url.isEmpty) {
    toast(context, 'سيُضاف الرابط قريبًا إن شاء الله');
  } else {
    openLink(url);
  }
}

/// Tells the reader when a newer APK is on GitHub (Android only).
class Updates {
  static final newer = ValueNotifier<int>(0);

  static Future<void> check() async {
    if (kIsWeb || appBuild == 0) return;
    try {
      final r = await http.get(Uri.parse('https://api.github.com/repos/$repo/releases/latest')).timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) return;
      final tag = (jsonDecode(r.body) as Map<String, dynamic>)['tag_name'] as String? ?? '';
      final n = int.tryParse(tag.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (n > appBuild) newer.value = n;
    } catch (_) {}
  }
}
