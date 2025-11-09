//
// © 2025-present https://github.com/jcarnaxide
//

package org.godotengine.plugin.android.inappupdate;

import android.app.Activity;

import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.UsedByGodot;

public class InAppUpdatePlugin extends GodotPlugin {
	public static final String CLASS_NAME = InAppUpdatePlugin.class.getSimpleName();
	static final String LOG_TAG = "godot::" + CLASS_NAME;

	Activity activity;

	public InAppUpdatePlugin(Godot godot) {
		super(godot);
	}

	@NonNull
	@Override
	public String getPluginName() {
		return CLASS_NAME;
	}

	@UsedByGodot
	public void hello_world() {
		Log.d(LOG_TAG, "hello_world()");
		activity.runOnUiThread(() -> {
            Toast.makeText(activity, "Hello World", Toast.LENGTH_LONG).show();
            Log.v(CLASS_NAME, "Hello World");
		});
	}
}
