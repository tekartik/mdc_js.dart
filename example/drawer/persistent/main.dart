// Copyright (c) 2017, alex. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_mdc_js/loader.dart';
import 'package:tekartik_app_utils/material_asset/loader.dart';
import 'package:tekartik_mdc_js/mdc_js.dart';

main() async {
  await waitAll([
    () => loadMdcCssJs(),
    () => loadMaterialIconCss(),
    () => loadRobotoFontCss()
  ]);
  //await autoInit();
  var drawerEl = document.querySelector('.mdc-persistent-drawer');
  //var MDCPersistentDrawer = mdc.drawer.MDCPersistentDrawer;
  var drawer = new MDCPersistentDrawer(drawerEl);
  document.querySelector('.demo-menu').onClick.listen((_) {
    drawer.open = !drawer.open;
  });
  drawerEl.on['MDCPersistentDrawer:open'].listen((_) {
    print('Received MDCPersistentDrawer:open');
  });
  drawerEl.on['MDCPersistentDrawer:close'].listen((_) {
    print('Received MDCPersistentDrawer:close');
  });
}
