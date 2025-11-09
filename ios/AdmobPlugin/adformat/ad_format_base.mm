//
// © 2025-present https://github.com/jcarnaxide
//

#import "ad_format_base.h"

@implementation AdFormatBase

static BOOL _pauseOnBackground = NO;

+ (BOOL) pauseOnBackground {
	return _pauseOnBackground;
}

+ (void) setPauseOnBackground:(BOOL) pause {
	_pauseOnBackground = pause;
}

@end
