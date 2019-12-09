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
