import 'package:tekartik_browser_utils/css_utils.dart';
import 'dart:async';

import 'package:tekartik_browser_utils/browser_utils_import.dart';

var _mdcJsLocker = new SynchronizedLock();
var _mdcCssLocker = new SynchronizedLock();
var _mscJsLoaded = false;
var _mscCssLoaded = false;

bool get isMdcJsLoaded => _mscJsLoaded;
bool get isMdcCssLoaded => _mscCssLoaded;

Future loadMdcJs() async {
  if (!_mscJsLoaded) {
    await _mdcJsLocker.synchronized(() async {
      await _loadMdcJs();
      _mscJsLoaded = true;
    });
  }
}

Future loadMdcCss() async {
  if (!_mscCssLoaded) {
    await _mdcCssLocker.synchronized(() async {
      await _loadMdcCss();
      _mscCssLoaded = true;
    });
  }
}

Future _loadMdcJs() async {
  await loadJavascriptScript("packages/mdc/material-components-web.min.js");
}

Future _loadMdcCss() async {
  await loadStylesheet("packages/mdc/material-components-web.min.css");
}

Future loadMdcCssJs() async {
  await waitAll([
    () async {
      await loadMdcCss();
    },
    () async {
      await loadMdcJs();
    }
  ]);
}
