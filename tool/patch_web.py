"""Runs on GitHub after `flutter create --platforms web`: Arabic title,
description, icons and a loading screen for the website."""
import json
import re
import shutil
from pathlib import Path

TITLE = "قناة الدروبي"
DESC = "قناة الدروبي — أخبار اليمن والعالم لحظة بلحظة: العاجل، والتقارير، والمقاطع، والبث المباشر."

index = Path("web/index.html")
h = index.read_text(encoding="utf-8")
h = re.sub(r"<html[^>]*>", '<html lang="ar" dir="rtl">', h, count=1)
h = re.sub(r"<title>.*?</title>", f"<title>{TITLE}</title>", h, count=1, flags=re.S)
h = re.sub(r'<meta name="description" content="[^"]*">', f'<meta name="description" content="{DESC}">', h, count=1)
if 'property="og:title"' not in h:
    h = h.replace("</head>",
                  f'  <meta property="og:title" content="{TITLE}">\n'
                  f'  <meta property="og:description" content="{DESC}">\n'
                  f'  <meta property="og:image" content="icons/Icon-512.png">\n</head>', 1)
h = h.replace('content="aldroubi"', f'content="{TITLE}"')
if 'id="loading"' not in h:
    h = h.replace("<body>", '''<body>
  <style>
    #loading { position: fixed; inset: 0; display: flex; flex-direction: column; align-items: center;
      justify-content: center; background: #FFFFFF; z-index: 9; transition: opacity .4s; }
    #loading img { width: 128px; height: 128px; border-radius: 30px; box-shadow: 0 6px 24px rgba(0,0,0,.15); animation: pulse 1.6s ease-in-out infinite; }
    #loading p { color: #111111; font: 16px sans-serif; margin-top: 22px; }
    @keyframes pulse { 0%,100% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.05); opacity: .8; } }
  </style>
  <div id="loading"><img src="icons/Icon-192.png" alt=""><p>جارٍ فتح «قناة الدروبي»…</p></div>
  <script>
    window.addEventListener('flutter-first-frame', function () {
      var l = document.getElementById('loading');
      if (l) { l.style.opacity = 0; setTimeout(function () { l.remove(); }, 450); }
    });
  </script>''', 1)
index.write_text(h, encoding="utf-8")

mf = Path("web/manifest.json")
j = json.loads(mf.read_text(encoding="utf-8"))
j.update(name=TITLE, short_name="الدروبي", description=DESC,
         background_color="#FFFFFF", theme_color="#111111", lang="ar", dir="rtl")
mf.write_text(json.dumps(j, ensure_ascii=False, indent=2), encoding="utf-8")

for f in Path("tool/web_icons").glob("*.png"):
    dest = Path("web") / ("favicon.png" if f.name == "favicon.png" else f"icons/{f.name}")
    shutil.copy(f, dest)
print("Web patched")
