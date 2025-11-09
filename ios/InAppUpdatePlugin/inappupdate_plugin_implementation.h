//
// © 2025-present https://github.com/jcarnaxide
//

#ifndef inappupdate_plugin_implementation_h
#define inappupdate_plugin_implementation_h


class InAppUpdatePlugin : public Object {
	GDCLASS(InAppUpdatePlugin, Object);

private:
	static InAppUpdatePlugin* instance; // Singleton instance

	id<NSObject> foregroundObserver; // Notification observer token

	void hello_world();

public:
 
	static InAppUpdatePlugin* get_singleton();

	InAppUpdatePlugin();
	~InAppUpdatePlugin();
};

#endif /* inappupdate_plugin_implementation_h */
