//
// © 2025-present https://github.com/jcarnaxide
//

#ifndef inappupdate_plugin_implementation_h
#define inappupdate_plugin_implementation_h

#include "core/object/class_db.h"

class InAppUpdatePlugin : public Object {
	GDCLASS(InAppUpdatePlugin, Object);

private:
	static InAppUpdatePlugin* instance; // Singleton instance

	void hello_world();

public:
 
	static InAppUpdatePlugin* get_singleton();

	InAppUpdatePlugin();
	~InAppUpdatePlugin();
};

#endif /* inappupdate_plugin_implementation_h */
