//
//  DeepAR.h
//
//  Copyright © 2017 DeepAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARView.h"

//! Project version number for DeepAR.
FOUNDATION_EXPORT double deepar_sdkVersionNumber;

//! Project version string for DeepAR.
FOUNDATION_EXPORT const unsigned char deepar_sdkVersionString[];


@interface DeepARiOS : NSObject

+ (ARView*)createARView:(CGRect)rect andDelegate:(id<ARViewDelegate>)delegate;

@end

