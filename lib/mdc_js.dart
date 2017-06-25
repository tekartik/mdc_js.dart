@JS('mdc')
library mdc;

import "package:js/js.dart";
import 'package:tekartik_browser_utils/browser_utils_import.dart';

@JS()
external autoInit();

/*
@JS('textfield.MDCTextfield')
class MDCTextfield {
  external static MDCTextfield attachTo(Element root);
  external MDCTextfield(Element root);
  external destroy();
  external initialSyncWithDom();
  external InputElement get input_;
  external get label_;
  external bool get disabled;
  external set disabled(bool disabled);
}
*/
@JS('drawer.MDCPersistentDrawer')
class MDCPersistentDrawer {
  external MDCPersistentDrawer(Element root);
  external bool get open;
  external set open(bool open);
}

abstract class _Drawer {
  external bool get open;
  external set open(bool open);
}

@JS('drawer.MDCTemporaryDrawer')
class MDCTemporaryDrawer extends _Drawer {
  external MDCTemporaryDrawer(Element root);
}
