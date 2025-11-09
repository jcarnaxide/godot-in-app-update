// InAppUpdateLogger.m
#import "inappupdate_logger.h"

// Define and initialize the shared os_log_t instance
os_log_t inappupdate_log;

__attribute__((constructor)) // Automatically runs at program startup
static void initialize_inappupdate_log() {
	inappupdate_log = os_log_create("org.godotengine.plugin.ios.inappupdate", "InAppUpdatePlugin");
}
