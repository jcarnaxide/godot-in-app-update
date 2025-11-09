//
// © 2025-present https://github.com/jcarnaxide
//

#ifndef banner_h
#define banner_h

#import "ad_format_base.h"
#import "load_ad_request.h"

#import "ad_position.h"


@interface BannerAd : AdFormatBase <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView* bannerView;
@property (nonatomic, strong) NSString* adUnitId;
@property (nonatomic) GADAdSize adSize;
@property (nonatomic) AdPosition adPosition;
@property (nonatomic) BOOL isLoaded;

- (instancetype) initWithID:(NSString*) adId;
- (void) load:(LoadAdRequest*) adData;
- (void) destroy;
- (void) hide;
- (void) show;
- (int) getWidth;
- (int) getHeight;
- (int) getWidthInPixels;
- (int) getHeightInPixels;

@end

#endif /* banner_h */
