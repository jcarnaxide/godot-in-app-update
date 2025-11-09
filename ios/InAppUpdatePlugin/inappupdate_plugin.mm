//
// © 2025-present https://github.com/jcarnaxide
//
// inappupdate_plugin.mm
//

#import <Foundation/Foundation.h>

#import "inappupdate_plugin.h"
#import "inappupdate_plugin_implementation.h"
#import "inappupdate_logger.h"

#import "core/config/engine.h"


InAppUpdatePlugin *inappupdate_plugin;

void inappupdate_plugin_init() {
	os_log_debug(inappupdate_log, "InAppUpdatePlugin: Initializing plugin at timestamp: %f", [[NSDate date] timeIntervalSince1970]);

	inappupdate_plugin = memnew(InAppUpdatePlugin);
	Engine::get_singleton()->add_singleton(Engine::Singleton("InAppUpdatePlugin", inappupdate_plugin));
	os_log_debug(inappupdate_log, "InAppUpdatePlugin: Singleton registered");
}

void inappupdate_plugin_deinit() {
	os_log_debug(inappupdate_log, "InAppUpdatePlugin: Deinitializing plugin");
	inappupdate_log = NULL; // Prevent accidental reuse

	if (inappupdate_plugin) {
		memdelete(inappupdate_plugin);
		inappupdate_plugin = nullptr;
	}
}
