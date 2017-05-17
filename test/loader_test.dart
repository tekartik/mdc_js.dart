@TestOn("browser")
import 'package:tekartik_mdc_js/loader.dart';
import 'package:test/test.dart';

void main() {
  group('mdc_loader', () {
    test('load', () async {
      expect(isMdcJsLoaded, isFalse);
      await loadMdcJs();
      expect(isMdcJsLoaded, isTrue);
      await loadMdcJs();
    });

    test('load_css', () async {
      expect(isMdcCssLoaded, isFalse);
      await loadMdcCssJs();
      expect(isMdcCssLoaded, isTrue);
      await loadMdcCssJs();
    });
  });
}
