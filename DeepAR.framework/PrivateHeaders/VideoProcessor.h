#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ARView.h"

@protocol VideoProcessorDelegate <NSObject>

- (void)progress:(float)progress faceData:(MultiFaceData)faceData;
- (void)didFinishProcessing:(NSString*)videoPath;
- (void)numberOfFacesVisibleChanged:(NSInteger)facesVisible;
@end

@interface VideoProcessor : NSObject

@property (nonatomic, weak) id<VideoProcessorDelegate> delegate;

- (instancetype)init;
- (void)processVideo:(NSURL*)videoUrl;
- (void)switchEffectWithSlot:(NSString*)slot path:(NSString*)path face:(uint32_t)face;
- (void)clearSession;

@end
