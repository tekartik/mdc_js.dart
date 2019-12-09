import 'dart:async';

import 'package:tekartik_browser_utils/browser_utils_import.dart';
import 'package:tekartik_browser_utils/css_utils.dart';

JavascriptScriptLoader _mdcJsLoader = JavascriptScriptLoader(
    'packages/tekartik_mdc_asset/material-components-web.min.js');
StylesheetLoader _mdcCssLoader = StylesheetLoader(
    'packages/tekartik_mdc_asset/material-components-web.min.css');

FutureOr loadMdcJs() => _mdcJsLoader.run();

Future loadMdcCss() => _mdcCssLoader.run();

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
