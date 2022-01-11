#include "include/dart_dl_api/dart_dl_api_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define DART_DL_API_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), dart_dl_api_plugin_get_type(), \
                              DartDlApiPlugin))

struct _DartDlApiPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(DartDlApiPlugin, dart_dl_api_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void dart_dl_api_plugin_handle_method_call(
    DartDlApiPlugin* self,
    FlMethodCall* method_call) {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));

  fl_method_call_respond(method_call, response, nullptr);
}

static void dart_dl_api_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(dart_dl_api_plugin_parent_class)->dispose(object);
}

static void dart_dl_api_plugin_class_init(DartDlApiPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = dart_dl_api_plugin_dispose;
}

static void dart_dl_api_plugin_init(DartDlApiPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  DartDlApiPlugin* plugin = DART_DL_API_PLUGIN(user_data);
  dart_dl_api_plugin_handle_method_call(plugin, method_call);
}

void dart_dl_api_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  DartDlApiPlugin* plugin = DART_DL_API_PLUGIN(
      g_object_new(dart_dl_api_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "dart_dl_api",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}