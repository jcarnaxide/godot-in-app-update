#
# © 2025-present https://github.com/jcarnaxide
#

class_name InAppUpdateAndroidExportConfig extends InAppUpdateExportConfig

const ANDROID_CONFIG_FILE_PATH: String = "res://addons/" + PLUGIN_NAME + "/android_export.cfg"


func get_config_file_path() -> String:
	return ANDROID_CONFIG_FILE_PATH
