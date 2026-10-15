import 'dart:async';

import 'package:tekartik_browser_utils/css_utils.dart';

// Copied from tekartik/app_utils.dart (archived), the drawer examples were its
// only users here.
Future loadMaterialIconCss() async {
  await loadStylesheet(
      'packages/tekartik_material_asset/font/material-icons/material-icons.css');
}

Future loadRobotoFontCss() async {
  await loadStylesheet(
      'packages/tekartik_material_asset/font/roboto/roboto-fonts.css');
}
