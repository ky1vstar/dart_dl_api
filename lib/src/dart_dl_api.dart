import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'bindings.dart';
import 'types.dart';

class DartDlApi {
  const DartDlApi._();

  static DartDlApiBindings? _bindings;

  static void ensureInitialized() {
    if (_bindings != null) return;

    final DynamicLibrary lib;
    if (Platform.isIOS || Platform.isMacOS) {
      lib = DynamicLibrary.process();
    } else if (Platform.isAndroid) {
      lib = DynamicLibrary.open("libdart_dl_api.so");
    } else if (Platform.isWindows) {
      List<String> executableDirectory = Platform.resolvedExecutable.split('/')
        ..removeLast();
      print(Directory(path.joinAll(executableDirectory)).listSync());
      lib = DynamicLibrary.open(
        path.joinAll(executableDirectory + ["dart_dl_api.dll"]),
      );
    } else {
      throw UnsupportedError(
        'package:dart_dl_api does not support ${Platform.operatingSystem}'
        ' platform.',
      );
    }

    _bindings = DartDlApiBindings.initialized(lib);
  }

  static bool isError(Object object) {
    ensureInitialized();
    final result = _bindings!.Dart_IsError_DL(object);
    return result == 1;
  }

  static Object newApiError(String message) {
    ensureInitialized();
    final msgPtr = message.toNativeUtf8();
    try {
      return _bindings!.Dart_NewApiError_DL(msgPtr.cast());
    } finally {
      // malloc.free(msgPtr);
    }
  }

  static FinalizableHandle? newFinalizableHandle(
    Object object,
    Pointer<Void> peer,
    int externalAllocationSize,
    Pointer<NativeFunction<HandleFinalizer>> callback,
  ) {
    ensureInitialized();
    final ptr = _bindings!.Dart_NewFinalizableHandle_DL(
        object, peer, externalAllocationSize, callback);
    if (ptr == nullptr) {
      return null;
    } else {
      return FinalizableHandle(ptr);
    }
  }

  static void deleteFinalizableHandle(FinalizableHandle handle, Object object) {
    ensureInitialized();
    _bindings!.Dart_DeleteFinalizableHandle_DL(handle.pointer, object);
  }

  static void updateFinalizableExternalSize(
    FinalizableHandle handle,
    Object object,
    int externalAllocationSize,
  ) {
    ensureInitialized();
    _bindings!.Dart_UpdateFinalizableExternalSize_DL(
        handle.pointer, object, externalAllocationSize);
  }
}
