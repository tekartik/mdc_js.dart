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
}
