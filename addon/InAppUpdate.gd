#
# © 2025-present https://github.com/jcarnaxide
#

@tool
class_name InAppUpdate extends Node

const PLUGIN_SINGLETON_NAME: String = "@pluginName@"

var _plugin_singleton: Object


func hello_world() -> void:
	if _plugin_singleton == null:
		InAppUpdate.log_error("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)
	else:
		_plugin_singleton.helloWorld()


func _ready() -> void:
	if OS.has_feature("ios"):
		pass
	else:
		pass

	_update_plugin()


func _notification(a_what: int) -> void:
	if a_what == NOTIFICATION_APPLICATION_RESUMED:
		_update_plugin()


func _update_plugin() -> void:
	if _plugin_singleton == null:
		if Engine.has_singleton(PLUGIN_SINGLETON_NAME):
			_plugin_singleton = Engine.get_singleton(PLUGIN_SINGLETON_NAME)
			_connect_signals()
		elif not OS.has_feature("editor_hint"):
			InAppUpdate.log_error("%s singleton not found!" % PLUGIN_SINGLETON_NAME)


static func log_error(a_description: String) -> void:
	push_error(a_description)


static func log_warn(a_description: String) -> void:
	push_warning(a_description)


static func log_info(a_description: String) -> void:
	print_rich("[color=lime]INFO: %s[/color]" % a_description)
