import 'package:flutter_test/flutter_test.dart';
import 'package:dart_dl_api/dart_dl_api.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("library is loaded correctly", (_) async {
    expect(DartDlApi.ensureInitialized, returnsNormally);
  });

  testWidgets("library APIs is functional", (_) async {
    late Object error;
    expect(() {
      error = DartDlApi.newApiError("some error");
    }, returnsNormally);

    expect(DartDlApi.isError(error), true);

    expect(DartDlApi.isError(Object()), false);
  });
}
