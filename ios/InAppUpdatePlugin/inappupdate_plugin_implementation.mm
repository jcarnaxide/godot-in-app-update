//
// © 2025-present https://github.com/jcarnaxide
//

#import "inappupdate_plugin_implementation.h"

#import "inappupdate_logger.h"

#import <UIKit/UIKit.h>

InAppUpdatePlugin* InAppUpdatePlugin::instance = NULL;

void InAppUpdatePlugin::_bind_methods() {
	ClassDB::bind_method(D_METHOD("hello_world"), &InAppUpdatePlugin::hello_world);
}

void InAppUpdatePlugin::hello_world() {
	os_log_debug(inappupdate_log, "InAppUpdatePlugin hello_world()");

    // 1. Create the toast label
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height-100, 200, 35)];
    toastLabel.backgroundColor = [UIColor blackColor];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont systemFontOfSize:12.0];
    toastLabel.text = "Hello World";
    toastLabel.alpha = 0.0; // Start invisible
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = YES;

    // 2. Add it to the view
    [self.view addSubview:toastLabel];

    // Optional: Use auto layout for better constraint handling
    toastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [toastLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [toastLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [toastLabel.widthAnchor constraintEqualToConstant:200],
        [toastLabel.heightAnchor constraintEqualToConstant:35]
    ]];

    // 3. Animate its appearance and disappearance
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toastLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toastLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
    }];
}

InAppUpdatePlugin* InAppUpdatePlugin::get_singleton() {
	return instance;
}

InAppUpdatePlugin::InAppUpdatePlugin() {
	os_log_debug(inappupdate_log, "constructor InAppUpdatePlugin");

	ERR_FAIL_COND(instance != NULL);

	instance = this;
}

InAppUpdatePlugin::~InAppUpdatePlugin() {
	os_log_debug(inappupdate_log, "destructor InAppUpdatePlugin");

	if (instance == this) {
		instance = nullptr;
	}
}
