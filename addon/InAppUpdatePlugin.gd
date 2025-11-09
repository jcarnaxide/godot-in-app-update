#
# © 2025-present https://github.com/jcarnaxide
#

@tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME = "@pluginNodeName@"
const PLUGIN_PARENT_NODE_TYPE = "Node"
const PLUGIN_NAME: String = "@pluginName@"
const ANDROID_DEPENDENCIES: Array = [ @androidDependencies@ ]
const IOS_PLATFORM_VERSION: String = "@iosPlatformVersion@"
const IOS_FRAMEWORKS: Array = [ @iosFrameworks@ ]
const IOS_EMBEDDED_FRAMEWORKS: Array = [ @iosEmbeddedFrameworks@ ]
const IOS_LINKER_FLAGS: Array = [ @iosLinkerFlags@ ]

var android_export_plugin: AndroidExportPlugin
var ios_export_plugin: IosExportPlugin


func _enter_tree() -> void:
	add_custom_type(PLUGIN_NODE_TYPE_NAME, PLUGIN_PARENT_NODE_TYPE, preload("%s.gd" % PLUGIN_NODE_TYPE_NAME), preload("icon.png"))
	android_export_plugin = AndroidExportPlugin.new()
	add_export_plugin(android_export_plugin)
	ios_export_plugin = IosExportPlugin.new()
	add_export_plugin(ios_export_plugin)


func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NODE_TYPE_NAME)
	remove_export_plugin(android_export_plugin)
	android_export_plugin = null
	remove_export_plugin(ios_export_plugin)
	ios_export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME
	var _export_config: InAppUpdateAndroidExportConfig


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		return platform is EditorExportPlatformAndroid


	func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if debug:
			return PackedStringArray(["%s/bin/debug/%s-debug.aar" % [_plugin_name, _plugin_name]])
		else:
			return PackedStringArray(["%s/bin/release/%s-release.aar" % [_plugin_name, _plugin_name]])


	func _get_name() -> String:
		return _plugin_name


	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		if _supports_platform(get_export_platform()):
			_export_config = InAppUpdateAndroidExportConfig.new()
			if not _export_config.export_config_file_exists() or _export_config.load_export_config_from_file() != OK:
				_export_config.load_export_config_from_node()


	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		var deps: PackedStringArray = PackedStringArray(ANDROID_DEPENDENCIES)
		if _export_config and _export_config.enabled_mediation_networks.size() > 0:
			for __network in _export_config.enabled_mediation_networks:
				for __dependency in __network.android_dependencies:
					deps.append(__dependency)

		InAppUpdate.log_info("Android dependencies: %s" % str(deps))

		return deps


class IosExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME
	var _export_config: InAppUpdateIosExportConfig
	var _export_path: String


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		return platform is EditorExportPlatformIOS


	func _get_name() -> String:
		return _plugin_name


	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		if _supports_platform(get_export_platform()):
			_export_path = path.simplify_path()
			_export_config = InAppUpdateIosExportConfig.new()
			if not _export_config.export_config_file_exists() or _export_config.load_export_config_from_file() != OK:
				_export_config.load_export_config_from_node()

			for __framework in IOS_FRAMEWORKS:
				add_apple_embedded_platform_framework(__framework)

			for __framework in IOS_EMBEDDED_FRAMEWORKS:
				add_apple_embedded_platform_embedded_framework(__framework)

			for __flag in IOS_LINKER_FLAGS:
				add_apple_embedded_platform_linker_flags(__flag)


	func _export_end() -> void:
		if _supports_platform(get_export_platform()):
			_install_mediation_dependencies(_export_path.get_base_dir(), _export_path.get_file().get_basename())
