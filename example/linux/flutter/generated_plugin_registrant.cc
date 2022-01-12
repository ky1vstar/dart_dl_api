//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dart_dl_api/dart_dl_api_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dart_dl_api_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DartDlApiPlugin");
  dart_dl_api_plugin_register_with_registrar(dart_dl_api_registrar);
}
