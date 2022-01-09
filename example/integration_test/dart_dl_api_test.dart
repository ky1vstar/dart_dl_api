import 'package:flutter_test/flutter_test.dart';
import 'package:dart_dl_api/dart_dl_api.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test("library is loaded correctly", () {
    expect(DartDlApi.ensureInitialized, returnsNormally);
  });

  test("library APIs is functional", () {
    late Object error;
    expect(() {
      error = DartDlApi.newApiError("some error");
    }, returnsNormally);

    expect(DartDlApi.isError(error), true);

    expect(DartDlApi.isError(Object()), false);
  });
}
