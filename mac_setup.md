jcarnaxide: Help me understand the build system in this repo. I want to build this plugin from source for both platforms. I am running on a macOS. Also can you help me understand what installs I need to do as well

Workspace: Collecting workspace informationSummary — what the repo does and how the build is orchestrated
- The top-level build orchestrator is build.sh. It calls the Android gradle wrapper via `run_android_gradle_task` and the iOS build helper via `run_ios_build`.
- Android library build is performed by the Gradle project under build.gradle.kts (configuration pulled from android/config.gradle.kts). The wrapper used is gradlew.
- iOS build and pod handling are done by build.sh and the plugin’s Podfile template is Podfile. The plugin GDScript code that generates Podfile / runs CocoaPods is in AdmobPlugin.gd (see functions `_install_mediation_dependencies` and `_generate_podfile`).
- Export configuration is read by AdmobExportConfig.gd when generating platform settings.

Required installs on macOS
- Xcode (full app) + Xcode Command Line Tools (for compiling iOS).
- CocoaPods (for iOS): install via Ruby gem or Homebrew:
```bash
sudo gem install cocoapods
# or
brew install cocoapods
```
- Java JDK 17 (Gradle + build scripts target Java 17). Set JAVA_HOME to the JDK 17 path:
```bash
# example (macOS system java tool)
export JAVA_HOME=$(/usr/libexec/java_home -v17)
```
- Android SDK (via Android Studio or command-line tools). Ensure ANDROID_SDK_ROOT (or ANDROID_HOME) is set and sdkmanager is available. Install the Android SDK platform and build-tools that match your compileSdk (see android/admob/build.gradle.kts).
- (Optional) Android Studio for SDK manager and easy setup; Gradle itself is via the repository wrapper, so you do not need to install a separate Gradle.

Notes about dependency resolution / pods
- The Android build uses the Gradle wrapper in gradlew and resolves dependencies declared in build.gradle.kts.
- The iOS Podfile is produced/used by the scripts and AdmobPlugin.gd. On macOS the build helper will attempt to auto-run pod install via the generated setup script (see `_install_mediation_dependencies`). If automatic install fails, run the generated setup script manually in the iOS project directory (or run pod install in the Podfile directory).

How to build (recommended)
- From the repository root you can use the orchestrating script:

Debug Android + iOS (default debug Android):
````bash
./script/build.sh -ai
````

Build Android release and iOS (full release + archives):
````bash
./script/build.sh -R
````

- The script calls Gradle tasks via `run_android_gradle_task` (which runs android/gradlew) and calls the iOS helper build.sh.
- If you want only Android, run the Gradle wrapper directly:
````bash
pushd android
./gradlew assembleDebug    # or assembleRelease
popd
````

Troubleshooting tips
- If Gradle complains about JAVA_HOME: verify JDK 17 and that JAVA_HOME is set (see gradlew checks).
- If Gradle fails due to missing Android SDK/platform: install the Android platform via sdkmanager or Android Studio to match compileSdk declared in build.gradle.kts.
- If CocoaPods fails: run pod repo update and run the generated setup script (the build scripts log where they generate it). The Podfile used/produced is Podfile and Pod install is triggered from the plugin export helper (`_install_mediation_dependencies` in addon/AdmobPlugin.gd).
- The iOS build helper scripts may download or require a specific Godot version and headers (see ios/script/build.sh); allow that script to run or pre-download Godot if desired.

Files and symbols referenced
- Orchestrator: build.sh (see functions `run_android_gradle_task`, `run_ios_build`)
- Android wrapper & build: gradlew, build.gradle.kts, config.gradle.kts
- iOS Podfile and scripts: Podfile, build.sh
- Plugin export & pod generation: AdmobPlugin.gd (functions `_install_mediation_dependencies`, `_generate_podfile`)
- Export config: AdmobExportConfig.gd

If you want, I can produce a one-liner checklist of install commands tuned to macOS (Homebrew-based) and an exact sequence of commands to run in your terminal. Which do you prefer?

jcarnaxide: I am a little confused about setting these JAVA_HOME and ANDROID_HOME environment variables. I figure exporting them once will only update my current terminal session. Is there a good way to have these set up for my project persistantly?

VS Code: 1. For a project-only (persistent per workspace) solution, add the environment vars to your workspace settings so VS Code's integrated terminal always receives them:
   - Create or edit .vscode/settings.json in your project and add the macOS terminal env entries (example shown below in the settings block).
2. For a global (all terminals, outside VS Code) solution, add export lines to your shell startup file on macOS (zsh is default):
   - Edit ~/.zprofile (login shells) or ~/.zshrc (interactive shells), add:
     export JAVA_HOME=/path/to/jdk
     export ANDROID_HOME=/Users/you/Library/Android/sdk
     export PATH="$JAVA_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
   - Save and run source ~/.zprofile or source ~/.zshrc.
3. Reload VS Code after changing workspace settings or your shell file so the integrated terminal picks up the changes.
4. Verify by opening a new integrated terminal and running:
   echo $JAVA_HOME
   echo $ANDROID_HOME

Settings to add in .vscode/settings.json (workspace) — this sets the variables for macOS integrated terminals:


Show in Settings Editor

Command to reload the window after changes:


Show in Command Palette

jcarnaxide: It looks like I need to install JDK on my mac, which version of JDK does this project expect?

GitHub Copilot: GitHub Copilot

Short answer: this project expects JDK 17.

What to do (recommended)
1. Install JDK 17 (Homebrew + Adoptium Temurin is simple):
```bash
brew install --cask temurin17
```
2. Persistently set JAVA_HOME for your macOS shell (zsh is default). Add this to ~/.zprofile:
```bash
# set JDK 17 for interactive & login shells
export JAVA_HOME=$(/usr/libexec/java_home -v17)
export PATH="$JAVA_HOME/bin:$PATH"
```
Then apply it:
```bash
source ~/.zprofile
```
3. Verify:
```bash
/usr/libexec/java_home -v17   # prints the JDK 17 install path
echo $JAVA_HOME
java -version
```

Fixing your workspace settings.json
- Your current file stores the command as a literal string. Options:
  - Prefer letting your shell export JAVA_HOME (no workspace override) — remove the entry from .vscode/settings.json.
  - Or paste the actual path returned by /usr/libexec/java_home -v17 into settings.json.

Example — replace the file with the actual path (run /usr/libexec/java_home -v17, then paste the output in place of the placeholder):
````json
{
    "terminal.integrated.env.osx": {
        "JAVA_HOME": "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
    }
}
````

Notes
- After changing shell files or workspace settings, restart VS Code (or reload the window) so the integrated terminal picks up the environment.
- For Android SDK, set ANDROID_HOME / ANDROID_SDK_ROOT in the same ~/.zprofile similarly and add platform-tools to PATH:
```bash
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
```

If you want, I can produce the exact sequence of terminal commands you should run now (install, set vars, verify) and the correct string to paste into your settings.json after you run /usr/libexec/java_home -v17.

jcarnaxide: Ok, java setup is good. Can you help me verify and setup my android sdk installation now. I installed the latest android studio on my mac, I just want to make sure that I have the correct tools installed this project expects.

GitHub Copilot: GitHub Copilot

Steps to verify and set up Android SDK for this project (macOS)

1) Find what compileSdk / build tools the project needs
- Run from the repo root:
````bash
# find the compileSdk value used by the Android Gradle files
grep -R --line-number "compileSdk" android || grep -R --line-number "targetSdk" android
````
Note the numeric SDK (eg. 33) shown — use that value in the steps below.

2) Check where Android Studio put the SDK and whether sdkmanager is available
````bash
# common default location
ls -la ~/Library/Android/sdk

# check environment
echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
echo "ANDROID_HOME=$ANDROID_HOME"
which sdkmanager || echo "sdkmanager not on PATH"
````

3) Install/ensure command-line tools and required packages
- If sdkmanager is missing, install command-line tools via Android Studio > SDK Manager > SDK Tools > Android SDK Command-line Tools, or install via sdkmanager once present.
- Install the platform, build-tools and platform-tools that match the compileSdk you found. Replace <API> and <BUILD_TOOLS_VER> with numbers from step 1 (eg. 33 and 33.0.2):
````bash
# example: set SDK_ROOT for this shell if not set
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"

# install required components
"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" \
  "platform-tools" \
  "platforms;android-<API>" \
  "build-tools;<BUILD_TOOLS_VER>" \
  "cmdline-tools;latest"
````

4) Accept licenses
````bash
"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --licenses
# press y for each license or pipe yes:
yes | "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --licenses
````

5) Persist environment variables (recommended)
- Add to ~/.zprofile (zsh default):
````bash
# add to ~/.zprofile
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
`````
Then run:
````bash
source ~/.zprofile
````

- (Optional) For VS Code project-only terminal env, put actual resolved path in .vscode/settings.json instead of a command string.

6) Verify installation
````bash
sdkmanager --list | head -n 40
adb --version
echo $ANDROID_SDK_ROOT
````

7) Try building the Android artifact from the repo
````bash
# from repo root
build.sh -a   # or: pushd android && ./gradlew assembleDebug && popd
````

If you paste the compileSdk value (or the output of the grep command) here I can give the exact sdkmanager install line (the exact platforms;android-<API> and build-tools;<VERSION>) to run.