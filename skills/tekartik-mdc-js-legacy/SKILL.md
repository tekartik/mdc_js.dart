---
name: tekartik-mdc-js-legacy
description: >-
  Use when reading or maintaining an old Dart 2 web app that wraps
  material-components-web (MDC 0.x) with tekartik_mdc_js: loadMdcJs,
  loadMdcCss, loadMdcCssJs from loader.dart, and the @JS('mdc') bindings
  autoInit, MDCPersistentDrawer, MDCTemporaryDrawer (the open property and the
  MDCTemporaryDrawer:open / :close events) from mdc_js.dart, together with the
  tekartik_mdc_asset bundle. Unmaintained: it does not build on Dart 3.
---

# Material Components Web bindings (tekartik_mdc_js)

`tekartik_mdc_js` is a tiny, **unmaintained** `package:js` wrapper over the
material-components-web 0.x javascript bundle: a loader for the bundled
css/js and bindings for two drawer components. It is Dart 2 code
(`sdk: '>=2.5.0 <3.0.0'`, pre null safety, `dart:html`, `@JS()` classes) whose
pubspec still uses the dead `git://` protocol, so it does **not** resolve or
compile with a Dart 3 SDK. Treat it as read-only history: do not add it to a
new project.

## Guidelines

* Status first: MDC 0.x is retired upstream (`MDCTemporaryDrawer` and
  `MDCPersistentDrawer` were merged into a single `MDCDrawer` in later MDC
  releases), and `@JS()` interop classes are gone from Dart 3. A Dart 3 port
  means rewriting the bindings with `dart:js_interop` + `package:web`; this
  repo has no successor package.
* If you really must resolve it, the `git://` urls in `pubspec.yaml` have to
  become `https://` first, and the whole dependency set (`tekartik_mdc_asset`,
  `tekartik_browser_utils`, `tekartik_app_utils`, `chrome_travis`) has to stay
  on its `dart2` ref. Do not "fix" the pubspec as a side effect of another
  task.
* Dependency form used by an app of that era (git, not on pub.dev):
  ```yaml
  dependencies:
    tekartik_mdc_js:
      git:
        url: https://github.com/tekartik/mdc_js.dart
  dev_dependencies:
    tekartik_mdc_asset:
      git:
        url: https://github.com/tekartik/mdc_asset.dart
  ```
  `tekartik_mdc_asset` is required by the app itself: the loaders hardcode the
  urls `packages/tekartik_mdc_asset/material-components-web.min.js` and
  `.min.css`, which `build_web_compilers`/`webdev` serve from that package's
  `lib/`.
* `package:tekartik_mdc_js/loader.dart` is the entry point, three functions
  built on `JavascriptScriptLoader` / `StylesheetLoader` from
  `tekartik_browser_utils` (each url is loaded once, later calls are no-ops):
  * `loadMdcJs()` - `FutureOr`, injects the js bundle (defines `window.mdc`).
  * `loadMdcCss()` - `Future`, injects the stylesheet.
  * `loadMdcCssJs()` - both in parallel; this is what `main()` should await
    before touching any MDC class.
* `package:tekartik_mdc_js/mdc_js.dart` is an `@JS('mdc')` library, so every
  binding reads the global `mdc` object created by the bundle. It exposes
  exactly three things:
  * `autoInit()` - calls `mdc.autoInit()`, which upgrades every element
    carrying `data-mdc-auto-init="MDCxxx"`. Use it for the components that
    have no Dart binding here.
  * `MDCPersistentDrawer(Element root)` - `mdc.drawer.MDCPersistentDrawer`,
    with a `bool open` getter/setter.
  * `MDCTemporaryDrawer(Element root)` - `mdc.drawer.MDCTemporaryDrawer`, same
    `bool open` property (inherited from a private base class).
  Nothing else is bound: the textfield binding is commented out in the source.
* Usage pattern: `await loadMdcCssJs()`, query the root element by its MDC
  class (`.mdc-persistent-drawer`, `.mdc-temporary-drawer`), construct the
  drawer with it, then toggle `drawer.open`. Constructing before the js bundle
  is loaded throws (`mdc` is undefined).
* Open/close notifications are plain DOM events on the root element, not Dart
  streams: `drawerEl.on['MDCTemporaryDrawer:open']` /
  `['MDCTemporaryDrawer:close']` (and the `MDCPersistentDrawer:`-prefixed pair
  for the persistent one).
* Fonts and icons are not loaded by this package. The examples pull them from
  `tekartik_app_utils` (`loadMaterialIconCss()`, `loadRobotoFontCss()` of
  `package:tekartik_app_utils/material_asset/loader.dart`, backed by the
  `tekartik_material_asset` assets) and wait for everything with `waitAll` from
  `package:tekartik_common_utils/async_utils.dart`.
* The markup is ordinary MDC 0.x markup (`mdc-typography` on `<body>`,
  `mdc-temporary-drawer` / `mdc-persistent-drawer` wrappers, `mdc-toolbar`);
  copy it from `example/drawer/*/index.html` rather than writing it from
  memory, and never mix it with a newer MDC bundle.
* Tests are `@TestOn('browser')` and only check that the loaders resolve; they
  run through `build_runner` (`pub run build_runner test -- -p chrome`), as
  `tool/travis.dart` does. There is no VM-runnable code in the package.

## Examples

All snippets are pre null safety Dart 2 code, as the package requires.

### Load the MDC bundle once, at startup

```dart
import 'package:tekartik_mdc_js/loader.dart';

Future main() async {
  // Injects packages/tekartik_mdc_asset/material-components-web.min.css
  // and .min.js, in parallel; safe to call more than once.
  await loadMdcCssJs();
}
```

### Temporary drawer toggled by a toolbar button

```dart
import 'dart:html';

import 'package:tekartik_mdc_js/loader.dart';
import 'package:tekartik_mdc_js/mdc_js.dart';

Future main() async {
  await loadMdcCssJs();

  var drawerEl = document.querySelector('.mdc-temporary-drawer');
  var drawer = MDCTemporaryDrawer(drawerEl);

  document.querySelector('.demo-menu').onClick.listen((_) {
    drawer.open = !drawer.open;
  });

  drawerEl.on['MDCTemporaryDrawer:open'].listen((_) {
    print('drawer opened');
  });
  drawerEl.on['MDCTemporaryDrawer:close'].listen((_) {
    print('drawer closed');
  });
}
```

### Persistent drawer with fonts and icons

```dart
import 'dart:html';

import 'package:tekartik_app_utils/material_asset/loader.dart';
import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_mdc_js/loader.dart';
import 'package:tekartik_mdc_js/mdc_js.dart';

Future main() async {
  await waitAll([
    () => loadMdcCssJs(),
    () => loadMaterialIconCss(),
    () => loadRobotoFontCss()
  ]);

  var drawerEl = document.querySelector('.mdc-persistent-drawer');
  var drawer = MDCPersistentDrawer(drawerEl);
  document.querySelector('.demo-menu').onClick.listen((_) {
    drawer.open = !drawer.open;
  });
}
```

### Components without a Dart binding: data-mdc-auto-init

```dart
import 'package:tekartik_mdc_js/loader.dart';
import 'package:tekartik_mdc_js/mdc_js.dart';

Future main() async {
  await loadMdcCssJs();
  // Upgrades every element with data-mdc-auto-init="MDCTextfield", etc.
  autoInit();
}
```

### Browser test

```dart
@TestOn('browser')
import 'package:tekartik_mdc_js/loader.dart';
import 'package:test/test.dart';

void main() {
  group('mdc_loader', () {
    test('load', () async {
      await loadMdcJs();
    });
    test('load_css', () async {
      await loadMdcCssJs();
    });
  });
}
```
