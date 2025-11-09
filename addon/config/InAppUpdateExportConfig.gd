#
# © 2025-present https://github.com/jcarnaxide
#

class_name InAppUpdateExportConfig extends RefCounted

const PLUGIN_NODE_TYPE_NAME = "@pluginNodeName@"
const PLUGIN_NAME: String = "@pluginName@"

const CONFIG_FILE_SECTION_GENERAL: String = "General"
const CONFIG_FILE_SECTION_DEBUG: String = "Debug"
const CONFIG_FILE_SECTION_RELEASE: String = "Release"
const CONFIG_FILE_SECTION_MEDIATION: String = "Mediation"

const CONFIG_FILE_KEY_IS_REAL: String = "is_real"
const CONFIG_FILE_KEY_APP_ID: String = "app_id"
const CONFIG_FILE_KEY_ENABLED_NETWORKS: String = "enabled_networks"

var is_real: bool
var debug_application_id: String
var real_application_id: String
var enabled_mediation_networks: Array[MediationNetwork] = []


func get_config_file_path() -> String:
	return ""


func export_config_file_exists() -> bool:
	return FileAccess.file_exists(get_config_file_path())


func load_export_config_from_file() -> Error:
	InAppUpdate.log_info("Loading export config from file!")

	var __result = Error.OK

	var __config_file_path = get_config_file_path()
	var __config_file = ConfigFile.new()

	var __load_result = __config_file.load(__config_file_path)
	if __load_result == Error.OK:
		is_real = __config_file.get_value(CONFIG_FILE_SECTION_GENERAL, CONFIG_FILE_KEY_IS_REAL)
		debug_application_id = __config_file.get_value(CONFIG_FILE_SECTION_DEBUG, CONFIG_FILE_KEY_APP_ID)
		real_application_id = __config_file.get_value(CONFIG_FILE_SECTION_RELEASE, CONFIG_FILE_KEY_APP_ID)
	
		if __config_file.has_section(CONFIG_FILE_SECTION_MEDIATION):
			if __config_file.has_section_key(CONFIG_FILE_SECTION_MEDIATION, CONFIG_FILE_KEY_ENABLED_NETWORKS):
				var __network_array: Array[String] = __config_file.get_value(CONFIG_FILE_SECTION_MEDIATION, CONFIG_FILE_KEY_ENABLED_NETWORKS)

				for __network in __network_array:
					if MediationNetwork.is_valid_tag(__network):
						enabled_mediation_networks.append(MediationNetwork.get_by_tag(__network))
					else:
						InAppUpdate.log_error("Invalid network tag '%s' in file %s!" % [__network, __config_file_path])
			else:
				InAppUpdate.log_error("Missing key %s in section %s of %s!" % [CONFIG_FILE_KEY_ENABLED_NETWORKS,
						CONFIG_FILE_SECTION_MEDIATION, __config_file_path])

		if is_real == null or debug_application_id == null or real_application_id == null:
			__result = Error.ERR_INVALID_DATA
		else:
			__result = load_platform_specific_export_config_from_file(__config_file)

		if __result != Error.OK:
			InAppUpdate.log_error("Invalid export config file %s!" % __config_file_path)
	else:
		__result = Error.ERR_CANT_OPEN
		InAppUpdate.log_error("Failed to open export config file %s!" % __config_file_path)

	if __result == Error.OK:
		print_loaded_config()

	return __result


func load_platform_specific_export_config_from_file(a_config_file: ConfigFile) -> Error:
	return Error.OK


func load_export_config_from_node() -> Error:
	InAppUpdate.log_info("Loading export config from node!")

	var __result = Error.OK

	var __in_app_update_node: InAppUpdate = get_plugin_node(EditorInterface.get_edited_scene_root())
	if not __in_app_update_node:
		var main_scene = load(ProjectSettings.get_setting("application/run/main_scene")).instantiate()
		__in_app_update_node = get_plugin_node(main_scene)

	if __in_app_update_node:
		is_real = __in_app_update_node.is_real
		debug_application_id = __in_app_update_node.android_debug_application_id
		real_application_id = __in_app_update_node.android_real_application_id
		enabled_mediation_networks = MediationNetwork.get_all_enabled(__in_app_update_node.enabled_networks)

		__result = load_platform_specific_export_config_from_node(__in_app_update_node)
		if __result == Error.OK:
			print_loaded_config()
		else:
			InAppUpdate.log_error("Invalid %s node for %s!" % [PLUGIN_NODE_TYPE_NAME, PLUGIN_NAME])
	else:
		InAppUpdate.log_error("%s failed to find %s node!" % [PLUGIN_NAME, PLUGIN_NODE_TYPE_NAME])
		__result = Error.ERR_UNCONFIGURED

	return __result


func load_platform_specific_export_config_from_node(a_node: InAppUpdate) -> Error:
	return Error.OK


func print_loaded_config() -> void:
	InAppUpdate.log_info("Loaded export configuration settings:")
	InAppUpdate.log_info("... is_real: %s" % ("true" if is_real else "false"))
	InAppUpdate.log_info("... debug_application_id: %s" % debug_application_id)
	InAppUpdate.log_info("... real_application_id: %s" % real_application_id)
	InAppUpdate.log_info("... enabled_mediation_networks: %s" % MediationNetwork.generate_tag_list(enabled_mediation_networks))


func get_plugin_node(a_node: Node) -> InAppUpdate:
	var __result: InAppUpdate

	if a_node is InAppUpdate:
		__result = a_node
	elif a_node.get_child_count() > 0:
		for __child in a_node.get_children():
			var __child_result = get_plugin_node(__child)
			if __child_result is InAppUpdate:
				__result = __child_result
				break

	return __result
