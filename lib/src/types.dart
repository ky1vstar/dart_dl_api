import 'dart:ffi';

typedef HandleFinalizer = Void Function(Pointer<Void> isolateCallbackData, Pointer<Void> peer);

class FinalizableHandle {
  FinalizableHandle(this.pointer);

  final Pointer<Void> pointer;
}