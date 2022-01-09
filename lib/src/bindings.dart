// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

typedef InitializeApiDLNative = IntPtr Function(Pointer<Void>);
typedef InitializeApiDL = int Function(Pointer<Void> data);

typedef HandleFinalizerNative = Void Function(Pointer<Void>, Pointer<Void>);

typedef IsErrorNative = Int8 Function(Handle);
typedef IsError = int Function(Object handle);

typedef NewApiErrorNative = Handle Function(Pointer<Int8>);
typedef NewApiError = Object Function(Pointer<Int8> error);

typedef NewFinalizableHandleNative = Pointer<Void> Function(Handle,
    Pointer<Void>, IntPtr, Pointer<NativeFunction<HandleFinalizerNative>>);
typedef NewFinalizableHandle = Pointer<Void> Function(
    Object object,
    Pointer<Void> peer,
    int external_allocation_size,
    Pointer<NativeFunction<HandleFinalizerNative>> callback);

typedef DeleteFinalizableHandleNative = Void Function(Pointer<Void>, Handle);
typedef DeleteFinalizableHandle = void Function(
    Pointer<Void> object, Object strong_ref_to_object);

typedef UpdateFinalizableExternalSizeNative = Void Function(
    Pointer<Void>, Handle, IntPtr);
typedef UpdateFinalizableExternalSize = void Function(Pointer<Void> object,
    Object strong_ref_to_object, int external_allocation_size);

class DartDlApiBindings {
  DartDlApiBindings.initialized(DynamicLibrary lib) {
    Dart_InitializeApiDL = lib
        .lookup<NativeFunction<InitializeApiDLNative>>("Dart_InitializeApiDL")
        .asFunction();

    final result = Dart_InitializeApiDL(NativeApi.initializeApiDLData);
    if (result != 0) {
      throw UnsupportedError(
        'package:dart_dl_api does not work with this version of the '
        'Dart DL API. Please update to a newer version of package:dart_dl_api.',
      );
    }

    Pointer<NativeFunction<T>> lookupFuncPtr<T extends Function>(
        String symbolName) {
      return lib.lookup<Pointer<NativeFunction<T>>>(symbolName).value;
    }

    Dart_IsError_DL =
        lookupFuncPtr<IsErrorNative>("Dart_IsError_DL").asFunction();
    Dart_NewApiError_DL =
        lookupFuncPtr<NewApiErrorNative>("Dart_NewApiError_DL").asFunction();
    Dart_NewFinalizableHandle_DL = lookupFuncPtr<NewFinalizableHandleNative>(
            "Dart_NewFinalizableHandle_DL")
        .asFunction();
    Dart_DeleteFinalizableHandle_DL =
        lookupFuncPtr<DeleteFinalizableHandleNative>(
                "Dart_DeleteFinalizableHandle_DL")
            .asFunction();
    Dart_UpdateFinalizableExternalSize_DL =
        lookupFuncPtr<UpdateFinalizableExternalSizeNative>(
                "Dart_UpdateFinalizableExternalSize_DL")
            .asFunction();
  }

  late final InitializeApiDL Dart_InitializeApiDL;

  late final IsError Dart_IsError_DL;
  late final NewApiError Dart_NewApiError_DL;

  late final NewFinalizableHandle Dart_NewFinalizableHandle_DL;
  late final DeleteFinalizableHandle Dart_DeleteFinalizableHandle_DL;
  late final UpdateFinalizableExternalSize
      Dart_UpdateFinalizableExternalSize_DL;
}
