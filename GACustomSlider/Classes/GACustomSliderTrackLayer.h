//
//  GACustomSliderTrackLayer.h
//  Pods
//
//  Created by Grzegorz Aperliński on 09.01.2017.
//
//

#import <QuartzCore/QuartzCore.h>
#import "GACustomSlider.h"

@class GACustomSlider;

@interface GACustomSliderTrackLayer : CALayer

@property (weak) GACustomSlider *slider;

@end
