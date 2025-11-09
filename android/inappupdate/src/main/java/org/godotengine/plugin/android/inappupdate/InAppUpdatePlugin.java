//
// © 2025-present https://github.com/jcarnaxide
//

package org.godotengine.plugin.android.inappupdate;

import android.util.Log;
import android.widget.Toast;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.UsedByGodot;

public class InAppUpdatePlugin extends GodotPlugin {
	public static final String CLASS_NAME = InAppUpdatePlugin.class.getSimpleName();
	static final String LOG_TAG = "godot::" + CLASS_NAME;


	public InAppUpdatePlugin(Godot godot) {
		super(godot);
	}

	@NonNull
	@Override
	public String getPluginName() {
		return CLASS_NAME;
	}

	@UsedByGodot
	public void helloWorld() {
		Log.d(LOG_TAG, "helloWorld()");
		activity.runOnUiThread(() -> {
            Toast.makeText(activity, "Hello World", Toast.LENGTH_LONG).show();
            Log.v(pluginName, "Hello World");
		});
	}
}
