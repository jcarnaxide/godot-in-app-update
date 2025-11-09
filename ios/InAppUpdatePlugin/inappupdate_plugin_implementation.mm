//
// © 2025-present https://github.com/jcarnaxide
//

#import "inappupdate_plugin_implementation.h"

#import "inappupdate_logger.h"

InAppUpdatePlugin* InAppUpdatePlugin::instance = NULL;

void InAppUpdatePlugin::hello_world() {
	os_log_debug(inappupdate_log, "InAppUpdatePlugin hello_world()");
}

InAppUpdatePlugin* InAppUpdatePlugin::get_singleton() {
	return instance;
}

InAppUpdatePlugin::InAppUpdatePlugin() {
	os_log_debug(inappupdate_log, "constructor InAppUpdatePlugin");

	ERR_FAIL_COND(instance != NULL);

	instance = this;
}

InAppUpdatePlugin::~InAppUpdatePlugin() {
	os_log_debug(inappupdate_log, "destructor InAppUpdatePlugin");

	if (instance == this) {
		instance = nullptr;
	}
}
