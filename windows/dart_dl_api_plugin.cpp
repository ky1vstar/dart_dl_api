#include "include/dart_dl_api/dart_dl_api_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

class DartDlApiPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DartDlApiPlugin();

  virtual ~DartDlApiPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void DartDlApiPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "dart_dl_api",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DartDlApiPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DartDlApiPlugin::DartDlApiPlugin() {}

DartDlApiPlugin::~DartDlApiPlugin() {}

void DartDlApiPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::ostringstream version_stream;
  version_stream << "Windows ";
  if (IsWindows10OrGreater()) {
    version_stream << "10+";
  } else if (IsWindows8OrGreater()) {
    version_stream << "8";
  } else if (IsWindows7OrGreater()) {
    version_stream << "7";
  }
  result->Success(flutter::EncodableValue(version_stream.str()));
}

}  // namespace

void DartDlApiPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  DartDlApiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
